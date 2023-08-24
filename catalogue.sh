script_location=$(pwd)
LOG=/tmp/roboshop.log
echo -e "\e[1;35m Configuring NodeJS Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Installing NOdeJS\e[0m"
yum install nodejs -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Add Application USER\e[0m"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "Refer Log file for more information, Log- ${LOG}"
mkdir -p /app &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Download APP Content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Deleting APP Old Content\e[0m"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Extracting APP Content\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Installing NodeJS Dependencies\e[0m"
cd /app
npm install &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Configuring Catalogue Service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Reload Systemd\e[0m"
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Start Catalogue Service\e[0m"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Configure Mongo Repo\e[0m"
cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
echo -e "\e[1;35m Load Schema\e[0m"
mongo --host mongodb-dev.devopsraja66.online </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    FAILURE
exit
    fi
