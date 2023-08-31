source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo -e "variable roboshop_rabbitmq_password is Missing"
  exit
fi
component=dispatch
schema_load=false

GOLANG