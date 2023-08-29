script_location=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32m SUCCESS \e[0m"
    else
      echo -e "\e[1;31m FAILURE \e[0m"
      echo -e "Refer Log file for more information,Log- ${LOG}"
  exit
      fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

NODEJS(){
  print_head "Configuring NodeJS Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check
  print_head "Installing NOdeJS"
  yum install nodejs -y &>>${LOG}
  status_check
  print_head "Add Application USER"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
  fi
  status_check
  mkdir -p /app &>>${LOG}
  status_check
  print_head  "Download APP Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check
  print_head  "Deleting APP Old Content"
  rm -rf /app/* &>>${LOG}
  status_check
  print_head "Extracting APP Content"
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  status_check
  print_head "Installing NodeJS Dependencies"
  cd /app
  npm install &>>${LOG}
  status_check
  print_head  "Configuring ${component} Service file"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check
  print_head  "Reload Systemd"
  systemctl daemon-reload &>>${LOG}
  status_check
  print_head  "Enable ${component} Service"
  systemctl enable ${component} &>>${LOG}
  status_check
  print_head  "Start ${component} Service"
  systemctl start ${component} &>>${LOG}
  status_check

  if [ {schema_load} == "true" ]; then
  print_head "Configure Mongo Repo"
  cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
  status_check
  print_head "Install Mongo Client"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check
  print_head "Load Schema"
  mongo --host mongodb-dev.devopsraja66.online </app/schema/${component}.js &>>${LOG}
  status_check
  fi
}