#!/bin/bash
# Author: Ryan Pillay (ryanpillayza@protonmail.com)
# for use in bash/shell environments only
# Make sure this script is executable (sudo chmod +x FLY.sh.sh)

#decrypts secret file and scrapes DB password
DBPASS=$(openssl aes-256-cbc -d -a -pbkdf2 -in secret -out secret.dec -k 8Sc5**y6QzUeJA%w; cat secret.dec; rm -f secret.dec)

#Checks if docker package is installed. If not, installs it. If installed, force upgrade to ensure latest version is installed
DOCKER_STATUS=$(dpkg-query -W --showformat='${Status}\n' docker | grep "install ok installed")
if [ "" = "$DOCKER_STATUS" ]; then
  sudo apt-get update
  sudo apt-get --yes install docker
else
  sudo apt-get update
  sudo apt-get --only-upgrade install docker
fi

#Builds docker image from dockerfile in current directory
docker build -t alfred:latest .
#Runs container using previously created image, setting relevant parameters, and executing sql script for schema, table, and manual entry insertion
docker run --detach --name ALFRED --env MARIADB_USER=batman --env MARIADB_PASSWORD=$DBPASS --env MARIADB_ROOT_PASSWORD=$DBPASS --env MARIADB_DATABASE=wayneindustries -v schema.sql:/docker-entrypoint-initdb.d/schema.sql -v /var/lib/mysql:/var/lib/mysql alfred:latest

#Checks if container is already running, if so, kills and removes it. Then restart the container with same params as above
CHECK=$(docker ps | grep ALFRED)
if [ "$CHECK" != "" ]; then
  docker kill ALFRED
  docker rm ALFRED
  docker run --detach --name ALFRED --env MARIADB_USER=batman --env MARIADB_PASSWORD=$DBPASS --env MARIADB_ROOT_PASSWORD=$DBPASS --env MARIADB_DATABASE=wayneindustries -v schema.sql:/docker-entrypoint-initdb.d/schema.sql -v /var/lib/mysql:/var/lib/mysql alfred:latest
fi
