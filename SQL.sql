--
-- Set default database
--
USE studentop;

--
-- Create table `django_content_type`
--
CREATE TABLE django_content_type (
  id int(11) NOT NULL AUTO_INCREMENT,
  app_label varchar(100) NOT NULL,
  model varchar(100) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 8,
AVG_ROW_LENGTH = 2340,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `django_content_type_app_label_model_76bd3d3b_uniq` on table `django_content_type`
--
ALTER TABLE django_content_type
ADD UNIQUE INDEX django_content_type_app_label_model_76bd3d3b_uniq (app_label, model);

--
-- Create table `auth_permission`
--
CREATE TABLE auth_permission (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  content_type_id int(11) NOT NULL,
  codename varchar(100) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 29,
AVG_ROW_LENGTH = 585,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `auth_permission_content_type_id_codename_01ab375a_uniq` on table `auth_permission`
--
ALTER TABLE auth_permission
ADD UNIQUE INDEX auth_permission_content_type_id_codename_01ab375a_uniq (content_type_id, codename);

--
-- Create foreign key
--
ALTER TABLE auth_permission
ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id)
REFERENCES django_content_type (id);

--
-- Create table `auth_user`
--
CREATE TABLE auth_user (
  id int(11) NOT NULL AUTO_INCREMENT,
  password varchar(128) NOT NULL,
  last_login datetime(6) DEFAULT NULL,
  is_superuser tinyint(1) NOT NULL,
  username varchar(150) NOT NULL,
  first_name varchar(30) NOT NULL,
  last_name varchar(150) NOT NULL,
  email varchar(254) NOT NULL,
  is_staff tinyint(1) NOT NULL,
  is_active tinyint(1) NOT NULL,
  date_joined datetime(6) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `username` on table `auth_user`
--
ALTER TABLE auth_user
ADD UNIQUE INDEX username (username);

--
-- Create table `student_module_message`
--
CREATE TABLE student_module_message (
  id int(11) NOT NULL AUTO_INCREMENT,
  files varchar(100) DEFAULT NULL,
  content longtext DEFAULT NULL,
  subject varchar(255) NOT NULL,
  last_updated datetime(6) NOT NULL,
  created datetime(6) NOT NULL,
  receiver_user_id int(11) DEFAULT NULL,
  sender_user_id int(11) DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE student_module_message
ADD CONSTRAINT student_module_message_receiver_user_id_e11805c2_fk_auth_user_id FOREIGN KEY (receiver_user_id)
REFERENCES auth_user (id);

--
-- Create foreign key
--
ALTER TABLE student_module_message
ADD CONSTRAINT student_module_message_sender_user_id_91ce599b_fk_auth_user_id FOREIGN KEY (sender_user_id)
REFERENCES auth_user (id);

--
-- Create table `django_admin_log`
--
CREATE TABLE django_admin_log (
  id int(11) NOT NULL AUTO_INCREMENT,
  action_time datetime(6) NOT NULL,
  object_id longtext DEFAULT NULL,
  object_repr varchar(200) NOT NULL,
  action_flag smallint(5) UNSIGNED NOT NULL,
  change_message longtext NOT NULL,
  content_type_id int(11) DEFAULT NULL,
  user_id int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE django_admin_log
ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id)
REFERENCES django_content_type (id);

--
-- Create foreign key
--
ALTER TABLE django_admin_log
ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id)
REFERENCES auth_user (id);

--
-- Create table `auth_user_user_permissions`
--
CREATE TABLE auth_user_user_permissions (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  permission_id int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` on table `auth_user_user_permissions`
--
ALTER TABLE auth_user_user_permissions
ADD UNIQUE INDEX auth_user_user_permissions_user_id_permission_id_14a6b632_uniq (user_id, permission_id);

--
-- Create foreign key
--
ALTER TABLE auth_user_user_permissions
ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id)
REFERENCES auth_permission (id);

--
-- Create foreign key
--
ALTER TABLE auth_user_user_permissions
ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id)
REFERENCES auth_user (id);

--
-- Create table `auth_group`
--
CREATE TABLE auth_group (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(150) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `name` on table `auth_group`
--
ALTER TABLE auth_group
ADD UNIQUE INDEX name (name);

--
-- Create table `auth_user_groups`
--
CREATE TABLE auth_user_groups (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  group_id int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `auth_user_groups_user_id_group_id_94350c0c_uniq` on table `auth_user_groups`
--
ALTER TABLE auth_user_groups
ADD UNIQUE INDEX auth_user_groups_user_id_group_id_94350c0c_uniq (user_id, group_id);

--
-- Create foreign key
--
ALTER TABLE auth_user_groups
ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id)
REFERENCES auth_group (id);

--
-- Create foreign key
--
ALTER TABLE auth_user_groups
ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id)
REFERENCES auth_user (id);

--
-- Create table `auth_group_permissions`
--
CREATE TABLE auth_group_permissions (
  id int(11) NOT NULL AUTO_INCREMENT,
  group_id int(11) NOT NULL,
  permission_id int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` on table `auth_group_permissions`
--
ALTER TABLE auth_group_permissions
ADD UNIQUE INDEX auth_group_permissions_group_id_permission_id_0cd325b0_uniq (group_id, permission_id);

--
-- Create foreign key
--
ALTER TABLE auth_group_permissions
ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id)
REFERENCES auth_permission (id);

--
-- Create foreign key
--
ALTER TABLE auth_group_permissions
ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id)
REFERENCES auth_group (id);

--
-- Create table `django_session`
--
CREATE TABLE django_session (
  session_key varchar(40) NOT NULL,
  session_data longtext NOT NULL,
  expire_date datetime(6) NOT NULL,
  PRIMARY KEY (session_key)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `django_session_expire_date_a5c62663` on table `django_session`
--
ALTER TABLE django_session
ADD INDEX django_session_expire_date_a5c62663 (expire_date);

--
-- Create table `django_migrations`
--
CREATE TABLE django_migrations (
  id int(11) NOT NULL AUTO_INCREMENT,
  app varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  applied datetime(6) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 19,
AVG_ROW_LENGTH = 910,
CHARACTER SET utf8,
COLLATE utf8_general_ci;