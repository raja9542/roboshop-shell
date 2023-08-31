source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo -e "Variable roboshop_rabbitmq_password is Needed"
  exit
fi
component=payment
schema_load=false

PYTHON