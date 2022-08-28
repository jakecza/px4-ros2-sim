#!/bin/bash
# Remove the docker container and image.
# set -e

# Find current directory and the repository root
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
REPO_ROOT_DIR=${CURR_DIR}

. ${REPO_ROOT_DIR}/scripts/config.bash

# Remove container.
CONT_ID=`docker container inspect -f '{{.Id}}' ${SIM_CONTAINER_NAME}`
if [ $? == 0 ]
then
    docker container rm -f ${CONT_ID}
    echo "Docker container '${SIM_CONTAINER_NAME}' removed."
fi