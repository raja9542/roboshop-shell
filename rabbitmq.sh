source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo -e "variable roboshop_rabbitmq_password is Missing"
  exit
fi
print_head "Configuring Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Configuring Rabbitmq Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG}
status_check
print_head "Installing Erlang & Rabbitmq"
yum install erlang rabbitmq-server -y &>>${LOG}
status_check
print_head "Enable Rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check
print_head "Start Rabbitmq server"
systemctl start rabbitmq-server
status_check
print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
status_check
print_head "Add Tags to Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check
print_head "Add Permissions to Application User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check