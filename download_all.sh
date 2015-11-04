#!/bin/bash
#
# download_all.sh
#
# Downloads Pivotal components from Pivnet using your Auth Token (found at the bottom of your Pivnet account page).
#
# Make sure you accepted EULA terms and conditions on the Pivnet download page for each component.
#

AUTH_TOKEN=GET_YOUR_OWN_AUTH_TOKEN
DOWNLOAD_DIRECTORY=/home/ubuntu/download_helper
LOG_DIRECTORY=/tmp

PIVOTAL_NETWORK=https://network.pivotal.io/api/v2
AUTHENTICATION_LOG_FILE=${LOG_DIRECTORY}/pivnet_authentication.log

echo -n "Test Pivotal Network Authentication Token: "
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token ${AUTH_TOKEN}" -X GET ${PIVOTAL_NETWORK}/authentication > ${AUTHENTICATION_LOG_FILE} 2>&1 
grep 'Status: 200' ${AUTHENTICATION_LOG_FILE} > /dev/null 2>&1
PIVOTAL_NETWORK_STATUS=$?  
if [ ${PIVOTAL_NETWORK_STATUS} -ne 0 ]
then
  echo "NOT OK. Check log."
  exit 1;
else
  echo "OK"
fi


function download_component {
  COMPONENT_NAME=$1
  COMPONENT_URL=$2
  COMPONENT_FILE=${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}
  echo "Downloading component: ${COMPONENT_NAME}"
  if [ -e ${COMPONENT_FILE} ]
  then
    echo "...................................................."
    echo "  File already exists!"
    echo "  Please remove the file first:"
    echo "    ${COMPONENT_FILE}"
    echo "...................................................."
  else
    echo "...................................................."
    wget -O "${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}" --post-data="" --header="Authorization: Token ${AUTH_TOKEN}" ${COMPONENT_URL}
    echo "...................................................."
  fi
}

function check_component {
  COMPONENT_NAME=$1
  COMPONENT_MD5=$2
  COMPONENT_FILE=${DOWNLOAD_DIRECTORY}/${COMPONENT_NAME}
  echo "Checking component: ${COMPONENT_FILE}"
  echo "...................................................."
  if [ -e ${COMPONENT_FILE} ]
  then
    echo "  Great! Component file exists:   ${COMPONENT_FILE}"
    CALCULATED_MD5=($(md5sum ${COMPONENT_FILE}))
    if [ "${CALCULATED_MD5}" == "${COMPONENT_MD5}" ]
    then
      echo "  Great! MD5 sums match:          ${COMPONENT_MD5}"
    else
      echo "  Bummer! MD5 sums don't match: EXPECTED MD5:${COMPONENT_MD5} ACTUAL MD5: ${CALCULATED_MD5}"
    fi
  else
    echo "Bummer! Component file does not exist: ${COMPONENT_FILE}"
    echo "Please make sure you have started the download of the component!"
  fi
  echo "...................................................."
}


  download_component cf-1.6.0.pivotal                                 https://network.pivotal.io/api/v2/products/elastic-runtime/releases/608/product_files/2947/download

# optional downloads

  download_component p-rabbitmq-1.4.6.0.pivotal                       https://network.pivotal.io/api/v2/products/pivotal-rabbitmq-service/releases/587/product_files/2912/download
  download_component p-mysql-1.7.0.0.pivotal                          https://network.pivotal.io/api/v2/products/p-mysql/releases/601/product_files/2943/download
  download_component p-redis-1.4.10.0.pivotal                         https://network.pivotal.io/api/v2/products/p-redis/releases/584/product_files/2910/download
  download_component p-spring-cloud-services-1.0.0.pivotal            https://network.pivotal.io/api/v2/products/p-spring-cloud-services/releases/603/product_files/2948/download
  download_component p-metrics-1.5.0.pivotal                          https://network.pivotal.io/api/v2/products/ops-metrics/releases/598/product_files/2937/download
  download_component p-push-notification-service-1.3.5.35.pivotal     https://network.pivotal.io/api/v2/products/push-notification-service/releases/599/product_files/2935/download
  download_component Pivotal_Single_Sign-On_1.0.0.pivotal             https://network.pivotal.io/api/v2/products/p-identity/releases/609/product_files/2960/download
  download_component p-tracker-1.2.1.15.pivotal                       https://network.pivotal.io/api/v2/products/pivotal-tracker-cf/releases/611/product_files/2968/download

# check MD5 for components

  check_component_cf cf-1.6.0.pivotal
  check_component    p-rabbitmq-1.4.6.0.pivotal                       cfc2d4ed514f6eea0da11b7b7b918bc6
  check_component    p-mysql-1.7.0.0.pivotal                          514c311b94691e2c9a5fb1c5d5668363
  check_component    p-redis-1.4.10.0.pivotal                         7b17195374d50f276b8bf95db566fdef
  check_component    p-spring-cloud-services-1.0.0.pivotal            8e0c80a32b3001e0bb77819185e61bfa
  check_component    p-metrics-1.5.0.pivotal                          6a8917c9a175aba890e213bd75e49d39
  check_component    p-push-notification-service-1.3.5.35.pivotal     2de9551f7f66645bdb437932505fd7de
  check_component    Pivotal_Single_Sign-On_1.0.0.pivotal             847a8fcfdeac05a6754aa3e686ff542b
  check_component    p-tracker-1.2.1.15.pivotal                       06081bd6b7b1c13701c5691d5e816cdf


