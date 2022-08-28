#!/bin/bash
# Build the docker image

# Find current directory and the repository root
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
REPO_ROOT_DIR=${CURR_DIR}

. ${REPO_ROOT_DIR}/scripts/config.bash

docker build -t ${DOCKER_HUB_PATH} -f ./px4-ros2-sim.dockerfile .
