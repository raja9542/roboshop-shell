source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "Variable root_mysql_password is Missing "
  exit
fi
print_head "Disable mysql Default module"
yum module disable mysql -y  &>>${LOG}
status_check
print_head "Copy MYSQL Repo File"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check
print_head "Install MYSQL"
yum install mysql-community-server -y &>>${LOG}
status_check
print_head "Enable mysql server"
systemctl enable mysqld &>>${LOG}
status_check
print_head "Start mysql Server"
systemctl start mysqld  &>>${LOG}
status_check
print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password}
if [ $? -eq 1 ]; then
  echo -e "password already changed"
fi
status_check