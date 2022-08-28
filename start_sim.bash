#!/bin/bash
# Start the docker container
# -> this file should be located in the repository's root

# Find current directory and the repository root
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )"
REPO_ROOT_DIR=${CURR_DIR}

. ${REPO_ROOT_DIR}/scripts/config.bash

# Check if container already running
docker container inspect ${SIM_CONTAINER_NAME} &> /dev/null
if [ $? == 0 ]
then
    # Container exists.
    if [ "$( docker container inspect -f '{{.State.Status}}' ${SIM_CONTAINER_NAME} )" == "running" ]
    then
        # Container is running.
        echo "Container '${SIM_CONTAINER_NAME}' is already running."
    else
        # Container exists but is not running.
        docker container start ${SIM_CONTAINER_NAME} &> /dev/null
        echo "Container '${SIM_CONTAINER_NAME}' started."
    fi
else

    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth
    if [ ! -f $XAUTH ]
    then
        touch $XAUTH
        chmod a+r $XAUTH
    fi
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

    PKG_DIR=${REPO_ROOT_DIR}/px4_ros2_sim
    echo "Mounts [${PKG_DIR}] from the host FS TO [${LINK_PKG_TO}] on the container (creates dir if non-existant)"

    docker container run \
        --detach \
        --tty \
        --name ${SIM_CONTAINER_NAME} \
        --volume=${PKG_DIR}:${LINK_PKG_TO}:rw \
        --volume=$XSOCK:$XSOCK:rw \
        --volume=$XAUTH:$XAUTH:rw \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --env="XAUTHORITY=${XAUTH}" \
        --env="DISPLAY" \
        --user ${SIM_CONTAINER_USER} \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        ${DOCKER_HUB_PATH} &> /dev/null




    echo "Container '${SIM_CONTAINER_NAME}' running."
fi

        # --gpus all \
