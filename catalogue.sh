script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32m SUCCESS \e[0m"
    else
      echo -e "\e[1;32m FAILURE \e[0m"
      echo -e "Refer Log file for more information,Log- ${LOG}"
  exit
      fi
}
echo -e "\e[1;35m Configuring NodeJS Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check
echo -e "\e[1;35m Installing NOdeJS\e[0m"
yum install nodejs -y &>>${LOG}
status_check
echo -e "\e[1;35m Add Application USER\e[0m"
useradd roboshop &>>${LOG}
status_check
mkdir -p /app &>>${LOG}
status_check
echo -e "\e[1;35m Download APP Content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check
echo -e "\e[1;35m Deleting APP Old Content\e[0m"
rm -rf /app/* &>>${LOG}
status_check
echo -e "\e[1;35m Extracting APP Content\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check
echo -e "\e[1;35m Installing NodeJS Dependencies\e[0m"
cd /app
npm install &>>${LOG}
status_check
echo -e "\e[1;35m Configuring Catalogue Service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check
echo -e "\e[1;35m Reload Systemd\e[0m"
systemctl daemon-reload &>>${LOG}
status_check
echo -e "\e[1;35m Enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${LOG}
status_check
echo -e "\e[1;35m Start Catalogue Service\e[0m"
systemctl start catalogue &>>${LOG}
status_check
echo -e "\e[1;35m Configure Mongo Repo\e[0m"
cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check
echo -e "\e[1;35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check
echo -e "\e[1;35m Load Schema\e[0m"
mongo --host mongodb-dev.devopsraja66.online </app/schema/catalogue.js &>>${LOG}
status_check