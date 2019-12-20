#!/bin/sh

# -----------------------
# how to run this script
# -----------------------
# Ensure gcloud is connected to the dapperlabs-ci project
# ./deploy-teamcity.sh update [—dry-run]

set -e

NAME=teamcity-y
ZONE=us-west1-c
# This External IP must already exist.
IP="35.233.150.25"
# An A/CNAME record that points this domain to the above IP must already.
DOMAIN=ci.eng.dapperlabs.com
# Problems with Letsencrypt Certificates will be sent to this email.
EMAIL=sre@dapperlabs.com
VERSION="2019.1.3"
# VERSION="2019.1.5"
# TODO: monitor if this is adequate for our needs.
# SIZE=small
SIZE=large

# # The '--preview' flag is like --dry-run
# gcloud deployment-manager deployments create ${NAME} \
# 	--template https://raw.githubusercontent.com/JetBrains/teamcity-google-template/master/teamcity.jinja \
# 	--properties zone:${ZONE},ipAddress:${IP},domainName:${DOMAIN},domainOwnerEmail:${EMAIL},installationSize:${SIZE},version:${VERSION}
# 	--verbosity=debug
echo $2

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "Usage: ./script.sh <create|update> [--dry-run]"
	exit 1
fi

if [ "$1" != "create" ] && [ "$1" != "update" ]; then
	echo "Invalid argument: $1"
	exit 1
fi

dry_run() {
	if [ $# -eq 2 ] && [ "$2" != "--dry-run" ]; then
		echo "Invalid argument: $2"
		exit 1
	elif [ "$2" == "--dry-run" ]; then
		echo "--preview"
	else
		echo ""
	fi
}


gcloud beta deployment-manager deployments $1 ${NAME} \
	--template `pwd`/teamcity.jinja \
	--properties zone:${ZONE},ipAddress:${IP},domainName:${DOMAIN},domainOwnerEmail:${EMAIL},installationSize:${SIZE},version:${VERSION} \
	--verbosity=debug $(dry_run $@)
