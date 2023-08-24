source common.sh
print_head "Copy Mongodb Repo file"
cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check
print_head "Install Mongodb"
yum install mongodb-org -y &>>${LOG}
status_check
print_head "Update Mongodb Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check
print_head "Enable Mongodb"
systemctl enable mongod &>>${LOG}
status_check
print_head "Start Mongodb"
systemctl restart mongod &>>${LOG}
status_check