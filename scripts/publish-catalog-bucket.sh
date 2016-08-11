#!/bin/bash

if [ -z ${CATALOG_LOCATION} ]; then
    echo "Error: CATALOG_LOCATION is not set. It is recommended to run this script from `make publish-catalog`"
    exit 1
fi

if [ -d services ]; 
then
    aws s3 sync services ${CATALOG_LOCATION} --acl public-read --delete
fi