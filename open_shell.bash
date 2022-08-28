#!/bin/bash
# Give the user a prompt on the docker container
set -e

# Find current directory and the repository root
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
REPO_ROOT_DIR=${CURR_DIR}

. ${REPO_ROOT_DIR}/scripts/config.bash

docker exec \
    -it \
    --user ${SIM_CONTAINER_USER} \
    ${SIM_CONTAINER_NAME} /bin/bash