source common.sh
print_head "Configuring NodeJS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check
print_head "Installing NOdeJS"
yum install nodejs -y &>>${LOG}
status_check
print_head "Add Application USER"
useradd roboshop &>>${LOG}
status_check
mkdir -p /app &>>${LOG}
status_check
print_head  "Download APP Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check
print_head  "Deleting APP Old Content"
rm -rf /app/* &>>${LOG}
status_check
print_head "Extracting APP Content"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check
print_head "Installing NodeJS Dependencies"
cd /app
npm install &>>${LOG}
status_check
print_head  "Configuring Catalogue Service file"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check
print_head  "Reload Systemd"
systemctl daemon-reload &>>${LOG}
status_check
print_head  "Enable Catalogue Service"
systemctl enable catalogue &>>${LOG}
status_check
print_head  "Start Catalogue Service"
systemctl start catalogue &>>${LOG}
status_check
print_head "Configure Mongo Repo"
cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check
print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${LOG}
status_check
print_head "Load Schema"
mongo --host mongodb-dev.devopsraja66.online </app/schema/catalogue.js &>>${LOG}
status_check