source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo -e "Variable root_mysql_password is Missing"
  exit
fi

component=shipping
schema_load=true
schema_type=mysql
MAVEN