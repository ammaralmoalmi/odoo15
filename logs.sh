#!/bin/bash
echo -e Will now tail logs...
docker-compose logs -f --tail=100 $1
