#!/bin/bash
echo ""
echo "Odoo Enterprise + Postgres"
echo "Maintainer: Benoit Lavorata"
echo "License: MIT"
echo "==="
echo ""

FILE=".env"
if [ -f $FILE ]; then
    echo ""
    echo "File $FILE exists, will now start: ..."
    export $(cat .env | xargs)

    echo ""
    echo "Create networks ..."
    docker network create $ODOO_CONTAINER_NETWORK
    docker network create $PG_CONTAINER_NETWORK

    echo ""
    echo "Create volumes ..."
    docker volume create --name ${SERVICE_NAME}_${PG_CONTAINER_VOLUME_DATA}
    docker volume create --name ${SERVICE_NAME}_${ODOO_CONTAINER_VOLUME_DATA}

    mkdir -p $ODOO_CONTAINER_HOST_BIND/local

    echo ""
    echo "Boot ..."

    #    docker-compose pull
    docker-compose up -d --remove-orphans $1

    echo " "
    echo "Odoo should be available at this address: "${ODOO_CONTAINER_VHOST}${SERVICE_DOMAIN}
else
    echo "File $FILE does not exist: deploying for first time"
    cp templates/.env.template .env

    echo "" >>.env
    echo "TARGET_UID=$UID" >>.env

    echo -e "Make sure to modify .env according to your needs, then use ./up.sh again."
fi
