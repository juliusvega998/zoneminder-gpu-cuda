#Update the db credentials here. The credentials here should be the same as the /.env file

# create databases
CREATE DATABASE IF NOT EXISTS `zm`;

# create zm user and grant rights
CREATE USER IF NOT EXISTS 'zmuser'@'%' IDENTIFIED BY 'insert_password_here';
GRANT ALL PRIVILEGES ON zm.* TO 'zmuser'@'%';
