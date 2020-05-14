from django.conf import settings
from django.contrib import admin
from django import forms
from django.contrib.auth.models import User
from django.db.models import QuerySet, Q
from django.utils.html import format_html

from . import models

from .models import Message


class BaseAdminForm(forms.ModelForm):
    """
    BaseAdminForm for common meta class for all the other admin form
    fields to display = ["subject", "content", "files", "receiver_user",]
    """

    class Meta:
        fields = [
            "subject",
            "content",
            "files",
            "receiver_user",
        ]


# MessageTeacherAdminForm Admin section
class MessageTeacherAdminForm(BaseAdminForm):
    """
    Custom admin form for teachers for sending messages to the students
    ------------------------------------------------------------------
    receiver_user: List of students who are presently associated with settings.STUDENT_GROUP_NAME
    model: Message
    """
    receiver_user = forms.ModelChoiceField(queryset=User.objects.filter(groups__name=settings.STUDENT_GROUP_NAME),
                                           label='Send Message To', required=True)

    class Meta(BaseAdminForm.Meta):
        model = models.Message


class MessageStudentAdminForm(BaseAdminForm):
    """
    Custom admin form for teachers for sending messages to the teachers
    ------------------------------------------------------------------
    receiver_user: List of teachers who are presently associated with settings.TEACHER_GROUP_NAME
    model: Message
    """
    receiver_user = forms.ModelChoiceField(queryset=User.objects.filter(groups__name=settings.TEACHER_GROUP_NAME),
                                           label='Send Message To', required=True)

    class Meta(BaseAdminForm.Meta):
        model = models.Message


class MessageSysManAdminForm(BaseAdminForm):
    """
    Custom admin form for teachers for sending messages to the students
    ------------------------------------------------------------------
    receiver_user: List of students who are presently associated with settings.TEACHER_GROUP_NAME
    model: Message
    """
    receiver_user = forms.ModelChoiceField(queryset=User.objects.filter(groups__name=settings.STUDENT_GROUP_NAME),
                                           label='Send Message To', required=True)

    class Meta(BaseAdminForm.Meta):
        model = models.Message


class MessageAdmin(admin.ModelAdmin):
    """
    Message Admin Section. Admin Ui to send and receive messages.
    -----------------------------------------------------------
    Fields to display on message admin list page = ["subject","created","sender_user","files_download",]
    Readonly fields : [ "last_updated", "created", "files_download", ] Hidden at the time sending message but
    can be seen at the receive details
    Link : ('subject',)
    List per page : 10
    can be filtered by : ("created",) field
    Message are searchable. One can search by 'subject' name or 'sender_user' name
    """
    list_display = [
        "subject",
        "created",
        "sender_user",
        "files_download",
    ]

    readonly_fields = [
        "last_updated",
        "created",
        "files_download",
    ]

    list_display_links = ('subject',)
    list_per_page = 10
    list_filter = ("created",)
    search_fields = ['subject__icontains', 'sender_user__username']

    def get_queryset(self, request):
        """
        Specific teacher will see only his department related messages
        :param request:
        :return: QuerySet<Message> | Messages which are either send by or receive by the current authenticated user
        """
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(Q(receiver_user_id=request.user) | Q(sender_user_id=request.user))

    def get_readonly_fields(self, request, obj=None):
        """
        Hide readonly fields from admin section
        :param request:
        :param obj: Message
        :return: None or readonly fields
        """
        if obj:  # Editing
            return self.readonly_fields
        return ()

    #
    def save_model(self, request, obj, form, change):
        """
        When sending new message , Saving sender information[id].
        :param request:
        :param obj: Message
        :param form:
        :param change:
        :return:
        """
        if not change:
            obj.sender_user = request.user
        obj.save()

    def get_form(self, request, obj=None, change=False, **kwargs):
        """
        Displaying Admin form based on user group. Teacher and System Managers will see list of students,
        but Student will see list of teacher.
        :param request:
        :param obj: Message
        :param change:
        :param kwargs:
        :return:
        """

        def is_user_student():
            """
            Checks where current user in student group
            :return: Boolean
            """
            if request.user.groups.filter(name=settings.STUDENT_GROUP_NAME).exists():
                return True
            return False

        def is_user_teacher():
            """
            Checks where current user in Teacher group
            :return: Boolean
            """
            if request.user.groups.filter(name=settings.TEACHER_GROUP_NAME).exists():
                return True
            return False

        def is_system_manager():
            """
            Checks where current user in System Manager group
            :return: Boolean
            """
            if request.user.groups.filter(name=settings.SYSTEM_MANAGER_GROUP).exists():
                return True
            return False

        # TODO: System Managers include
        if is_user_teacher() or is_system_manager():
            return MessageTeacherAdminForm
        elif is_user_student() :
            return MessageStudentAdminForm

    def files_download(self, obj):
        """
        Add custom download link for downloading attached files. Download link can be seen based on files existence.
        :param obj:string : Formatted Html
        :return:
        """
        if obj.files.name:
            return format_html('<a href="/media/{0}" download>{1}</a>'.format(
                obj.files, 'Download'))
        else:
            pass

    files_download.short_description = 'Download Files'


# Registering Message and messageAdmin into Django.Admin
admin.site.register(models.Message, MessageAdmin)
