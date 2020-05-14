from django.conf import settings
from django.contrib.auth.models import User
from django.db import models
from django.urls import reverse
from .validators import validate_file_extension


class Message(models.Model):
    """
    Message Model
    ---------------
    receiver_user: User who will receive the message.
    sender_user : user who will send the message
    files: Homework or Coursework file attachment with message
    content: Message content [Max 4000 Char]
    subject: Message Subject [Max 255 Char]
    last_updated : Last Updated date of message
    created : Message Created Date
    """
    # Relationships
    receiver_user = models.ForeignKey(User, on_delete=models.CASCADE,
                                      related_name='receiver', null=True, )
    sender_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
                                    related_name='sender', blank=True, null=True)

    # Fields
    files = models.FileField(upload_to="upload/files/", null=True, blank=True,
                             verbose_name='Upload Coursework or homework',
                             help_text='Allowed files Extensions [.pdf,.doc,.docx,.jpg,.png,.xlsx,.xls]',
                             validators=[validate_file_extension])
    content = models.TextField(max_length=4000, null=True, blank=True,
                               help_text='Maximum character allowed 4000', )
    subject = models.CharField(max_length=255, help_text='Maximum character allowed 255')

    last_updated = models.DateTimeField(auto_now=True, editable=False)
    created = models.DateTimeField(auto_now_add=True, editable=False)

    class Meta:
        ordering = ["-created"] # order By Created date

    def __str__(self):
        return str(self.subject)

    def get_absolute_url(self):
        return reverse("students_student_detail", args=(self.pk,))

    def get_update_url(self):
        return reverse("students_student_update", args=(self.pk,))
