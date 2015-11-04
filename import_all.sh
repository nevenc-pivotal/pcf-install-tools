#!/bin/bash
#
# import_all.sh
#
# Uploads (imports) Pivotal components into Pivotal Ops Manager, using upload API
# Components will show up in the left navigation bar in Pivotal Ops Manager UI.
#

DOWNLOAD_DIRECTORY=/home/ubuntu/download_helper
LOG_DIRECTORY=/tmp

OPSMGR_HOSTNAME=OPSMANAGER_HOSTNAME_OR_IP_GOES_HERE
OPSMGR_USERNAME=OPSMANAGER_ADMIN_USERNAME_GOES_HERE
OPSMGR_PASSWORD=OPSMANAGER_ADMIN_PASSWORD_GOES_HERE
OPSMGR_URL=https://${OPSMGR_HOSTNAME}/api/products

AUTHENTICATION_LOG_FILE=${LOG_DIRECTORY}/opsmgr_authentication.log

echo -n "Test Ops Manager: "
curl -i -k  -X GET ${OPSMGR_URL} -u ${OPSMGR_USERNAME}:${OPSMGR_PASSWORD} > ${AUTHENTICATION_LOG_FILE} 2>&1 
grep '"name":' ${AUTHENTICATION_LOG_FILE} > /dev/null 2>&1
PIVOTAL_NETWORK_STATUS=$?  
if [ ${PIVOTAL_NETWORK_STATUS} -ne 0 ]
then
  echo "NOT OK. Check log."
  exit 1;
else
  echo "OK"
fi

function upload_component {
  COMPONENT_NAME=$1
  COMPONENT_DOWNLOAD_URL=$2
  UPLOAD_LOG_FILE=${LOG_DIRECTORY}/upload.${COMPONENT_NAME}.log
  echo "Uploading component: ${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}"
  if [ ! -e ${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME} ]
  then
    echo "...................................................."
    echo "  File does not exists!"
    echo "  Please download the file first:"
    echo "    ${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}"
    echo "...................................................."
  else
    echo "...................................................."
    nohup curl -i -k ${OPSMGR_URL} -F 'product[file]=@'${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}'' -X POST -u ${OPSMGR_USERNAME}:${OPSMGR_PASSWORD} > ${UPLOAD_LOG_FILE} 2>&1 &
    echo "  Upload process is started for file ${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}."
    echo "  You can safely close this terminal window."
    echo "  NOHUP output is writing to a logfile: ${UPLOAD_LOG_FILE}"
    echo "...................................................."
  fi
}

######################################################################################################
# PCF 1.6 Components
######################################################################################################

# elastic runtime (core) 
  upload_component    cf-1.6.0.pivotal

# optional 
  upload_component    p-rabbitmq-1.4.6.0.pivotal
  upload_component    p-mysql-1.7.0.0.pivotal
  upload_component    p-redis-1.4.10.0.pivotal
  upload_component    p-spring-cloud-services-1.0.0.pivotal
  upload_component    p-metrics-1.5.0.pivotal
  upload_component    p-push-notification-service-1.3.5.35.pivotal
  upload_component    Pivotal_Single_Sign-On_1.0.0.pivotal
  upload_component    p-tracker-1.2.1.15.pivotal

######################################################################################################
# PCF 1.6 Updated Components
######################################################################################################

# upload_component    cf-1.6.1.pivotal
# upload_component    p-rabbitmq-1.4.7.0.pivotal
# upload_component    p-redis-1.4.11.0.pivotal
# upload_component    p-metrics-1.5.1.pivotal
# upload_component    Pivotal_Single_Sign-On_1.0.1.pivotal
# upload_component    p-tracker-1.3.1.1.pivotal


