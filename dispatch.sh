source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo -e "Variable roboshop_rabbitmq_password is Needed"
  exit
fi

component=dispatch
schema_load=false

GOLANG