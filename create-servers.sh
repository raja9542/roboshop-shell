#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
INSTANCE_TYPE=" "
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-02a55f2a99bb97993
DOMAIN_NAME=devopsraja66.online
HOSTED_ZONE_ID=Z09171912J6RDBH9U9MN3
env=dev

# if mysql or mongodb instance_type should be t3.medium , for all others it is t3.micro

for i in "${NAMES[@]}"
do
    if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t3.micro"
    fi
    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i-${env}.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done

# imporvement
# check instance is already created or not
# update route53 record


##!/bin/bash
#
###### Change these values ###
#ZONE_ID="Z09171912J6RDBH9U9MN3"
#DOMAIN="devopsraja66.online"
#SG_NAME="Devops"
#env=dev
##############################
#
#
#create_ec2() {
#  PRIVATE_IP=$(aws ec2 run-instances \
#      --image-id ${AMI_ID} \
#      --instance-type t3.micro \
#      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}, {Key=Monitor,Value=yes}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]"  \
#      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
#      --security-group-ids ${SGID} \
#      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
#
#  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" -e "s/DOMAIN/${DOMAIN}/" route53.json >/tmp/record.json
#  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json 2>/dev/null
#  if [ $? -eq 0 ]; then
#    echo "Server Created - SUCCESS - DNS RECORD - ${COMPONENT}.${DOMAIN}"
#  else
#     echo "Server Created - FAILED - DNS RECORD - ${COMPONENT}.${DOMAIN}"
#     exit 1
#  fi
#}
#
#
### Main Program
#AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
#if [ -z "${AMI_ID}" ]; then
#  echo "AMI_ID not found"
#  exit 1
#fi
#
#SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')
#if [ -z "${SGID}" ]; then
#  echo "Given Security Group does not exit"
#  exit 1
#fi
#
#
#for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch; do
#  COMPONENT="${component}-${env}"
#  create_ec2
#done
