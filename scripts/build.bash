#!/bin/bash
# Builds

set -e

. ./config.bash
. /opt/ros/${ROS2_DISTRO}/setup.bash
echo ${LD_LIBRARY_PATH}
echo $FASTRTPSGEN_DIR
# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
# export FASTRTPSGEN_DIR=/usr/local/bin/

# Check FastRTPSGen version
fastrtpsgen_version_out=""
if [[ -z $FASTRTPSGEN_DIR ]]; then
  fastrtpsgen_version_out="$FASTRTPSGEN_DIR/$(fastrtpsgen -version)"
else
  fastrtpsgen_version_out=$(fastrtpsgen -version)
fi
if [[ -z $fastrtpsgen_version_out ]]; then
  echo "FastRTPSGen not found! Please build and install FastRTPSGen..."
  exit 1
else
  fastrtpsgen_version="${fastrtpsgen_version_out: -5:-2}"
  if ! [[ $fastrtpsgen_version =~ ^[0-9]+([.][0-9]+)?$ ]] ; then
    fastrtpsgen_version="1.0"
    [ ! -v $verbose ] && echo "FastRTPSGen version: ${fastrtpsgen_version}"
  else
    [ ! -v $verbose ] && echo "FastRTPSGen version: ${fastrtpsgen_version_out: -5}"
  fi
fi

# Clean ros2_ws
# bash ./super_clean.bash

# # Simulate what the build server does to the uORB YAML file (single source of truth)
# # -> this ensures that the urtps_bridge_topics.yaml file recieved by both the PX4-Autopilot and 
# # px4_ros_com package is consistent
${PX4_FIRMWARE_DIR}/msg/tools/uorb_to_ros_urtps_topics.py \
	-i ${PX4_FIRMWARE_DIR}/msg/tools/urtps_bridge_topics.yaml \
	-o ${PX4_ROS_COM_DIR}/templates/urtps_bridge_topics.yaml

# 1) Build the Firmware repo
PX4_TARGET=px4_sitl_rtps
cd ${PX4_FIRMWARE_DIR}
git submodule sync --recursive
git submodule update --init --recursive
make ${PX4_TARGET}

# 2) Build the ROS2 ws
# sudo update-alternatives --set java $(update-alternatives --list java | grep "java-11")
cd ${ROS2_WS_DIR}
source /opt/ros/${ROS2_DISTRO}/setup.bash
colcon build --symlink-install --event-handlers console_direct+

# 3) Build the main pkg
cd ${LINK_PKG_TO}


echo "Build took $SECONDS seconds."

