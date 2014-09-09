#!/bin/bash

# Script to start and connect to a container with Fiji.
# Modified from https://pelle.io/delivering-gui-applications-with-docker/

# docker image to use
DOCKER_IMAGE_NAME="hajaalin/fijibox-lifeline-20140602"

# local name for the container
DOCKER_CONTAINER_NAME="$1"
INPUT="/mnt/lmu-active"
OUTPUT="/home/hajaalin/tmp/fijibox-output"

# check if container already present
TMP=$(docker ps -a | grep ${DOCKER_CONTAINER_NAME})
CONTAINER_FOUND=$?

TMP=$(docker ps | grep ${DOCKER_CONTAINER_NAME})
CONTAINER_RUNNING=$?

if [ $CONTAINER_FOUND -eq 0 ]; then

    echo -n "container '${DOCKER_CONTAINER_NAME}' found, "

    if [ $CONTAINER_RUNNING -eq 0 ]; then
	echo "already running"
	else
	echo -n "not running, starting..."
	TMP=$(docker start ${DOCKER_CONTAINER_NAME})
	echo "done"
	fi

else
    echo -n "container '${DOCKER_CONTAINER_NAME}' not found, creating..."
    CMD="docker run -d -P --name ${DOCKER_CONTAINER_NAME}"
    CMD="$CMD --volumes-from hajaalin-data"
    CMD="$CMD -v $INPUT:/input"
    CMD="$CMD -v $OUTPUT:/output"
    CMD="$CMD ${DOCKER_IMAGE_NAME}"
    TMP=$($CMD)
    echo "done"
fi

#wait for container to come up
sleep 2

# find ssh port
SSH_URL=$(docker port ${DOCKER_CONTAINER_NAME} 22)
SSH_URL_REGEX="(.*):(.*)"

SSH_INTERFACE=$(echo $SSH_URL | awk -F  ":" '/1/ {print $1}')
SSH_PORT=$(echo $SSH_URL | awk -F  ":" '/1/ {print $2}')

echo "ssh running at ${SSH_INTERFACE}:${SSH_PORT}"

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -X dev@${SSH_INTERFACE} -p ${SSH_PORT}
