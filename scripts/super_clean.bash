#!/bin/bash
# Clean the parts of the bulid needed to pick up changes to the uORB YAML file.
set -e

. ./config.bash

# Clean the firmware build.
cd ${PX4_FIRMWARE_DIR}
git reset --hard
git clean -dfx
git submodule foreach "git reset --hard; git clean -dfx"


# Clean the px4_msgs repo.
cd ${ROS2_WS_DIR}/src/px4_msgs
git reset --hard
git clean -dfx

# Clean the px4_ros_com repo.
cd ${ROS2_WS_DIR}/src/px4_ros_com
git reset --hard
git clean -dfx

# Clean the various build artifacts manually as there is no colcon clean.
cd ${ROS2_WS_DIR}
rm -rf build/ install/ log/

echo "Cleaned all PX4 code."
