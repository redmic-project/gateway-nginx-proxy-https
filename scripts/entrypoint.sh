#!/bin/sh

if [ -z "${PERSISTENT_PATH}" ]
then
	echo "PERSISTENT_PATH variable should be defined!"
	exit 1
fi

dhparamFile="${PERSISTENT_PATH}/dhparam.pem"
if [ ! -e "${dhparamFile}" ]
then
	echo "DHParam not found, generating.."
	openssl dhparam -out "${dhparamFile}" 4096
fi

nginx -g 'daemon off;'
