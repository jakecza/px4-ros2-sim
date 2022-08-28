#!/bin/bash
# Stop the docker container.
set -e

# Find current directory and the repository root
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
REPO_ROOT_DIR=${CURR_DIR}

. ${REPO_ROOT_DIR}/scripts/config.bash

if [ "$( docker container inspect -f '{{.State.Status}}' ${SIM_CONTAINER_NAME} )" == "running" ]
then
    # Container is running so stop it.
    docker stop ${SIM_CONTAINER_NAME} &> /dev/null
    sudo rm -rf /tmp/.docker.xauth/
    echo "Docker '${SIM_CONTAINER_NAME}' stopped."
else
    echo "Docker '${SIM_CONTAINER_NAME}' already stopped."
fi