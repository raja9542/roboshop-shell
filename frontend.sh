source common.sh
print_head "Install nginx"
yum install nginx -y &>>${LOG}
status_check
print_head  "Remove Nginx old content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check
print_head "Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
cd /usr/share/nginx/html/ &>>${LOG}
status_check
print_head "Extract Frontend Content"
unzip /tmp/frontend.zip &>>${LOG}
status_check
print_head "Copy Roboshop Nginx Config file"
cp ${script_location}/files/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check
print_head "enable nginx"
systemctl enable nginx &>>${LOG}
status_check
print_head "start nginx"
systemctl restart nginx &>>${LOG}
status_check