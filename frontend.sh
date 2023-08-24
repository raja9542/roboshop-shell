script_location=$(pwd)
LOG=/tmp/roboshop.log
echo -e "\e[36m Install nginx\e[0m"
yum install nginx -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[36m Remove Nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[36m Download Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
cd /usr/share/nginx/html/ &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[36m Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[36m Copy Roboshop Nginx Config file\e[0m"
cp ${script_location}/files/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[36m enable nginx\e[0m"
systemctl enable nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[36m start nginx\e[0m"
systemctl restart nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi