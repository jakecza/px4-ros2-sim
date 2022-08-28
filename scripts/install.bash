#!/bin/bash
# Installs

set -e

. ./config.bash
. /opt/ros/${ROS2_DISTRO}/setup.bash

# 1) General setup

# Install some extras (optional)
sudo apt-get install nano apt-utils
# sudo apt-get -y --no-install-recommends install ant openjdk-13-jre openjdk-13-jdk libvecmath-java

# Create folder structure
mkdir -p ${CLONES_DIR} ${APPS_DIR} ${ROS2_WS_DIR}
mkdir -p ${ROS2_WS_DIR}/src

# Install latest PX4 Autopilot firmware release
git clone https://github.com/PX4/PX4-Autopilot.git --recursive --branch ${PX4_FIRMWARE_BRANCH} ${PX4_FIRMWARE_DIR}
bash ${PX4_FIRMWARE_DIR}/Tools/setup/ubuntu.sh # setup using provided script
echo "Requires reboot before NuttX build targets"

sudo update-alternatives --set java $(update-alternatives --list java | grep "java-11") # setting of java 11 to default

# # b) Foonathan memory vender install
# cd ${CLONES_DIR}
# git clone https://github.com/eProsima/foonathan_memory_vendor.git ${CLONES_DIR}/foonathan_memory_vendor
# cd ${CLONES_DIR}/foonathan_memory_vendor
# mkdir build && cd build
# cmake ..
# cmake --build . --target install

# # c) Fast-RTPS install
# cd ${CLONES_DIR}
# git clone --recursive https://github.com/eProsima/Fast-DDS.git -b ${FAST_DDS_BRANCH} ${FAST_DDS_DIR}
# cd ${FAST_DDS_DIR}
# mkdir build && cd build
# cmake -DTHIRDPARTY=ON -DSECURITY=ON ..
# make -j$(nproc --all)
# sudo make install

# c) Fast-RTPS-Gen install
cd ${CLONES_DIR}
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b ${FAST_RTPS_GEN_BRANCH} ${FAST_RTPS_GEN_DIR}
cd ${FAST_RTPS_GEN_DIR}/gradle/wrapper
# Change value of 'distributionUrl' in gradle-wrapper.properties
sed -i '/distributionUrl/c\distributionUrl=https\://services.gradle.org/distributions/gradle-6.8.3-bin.zip' ./gradle-wrapper.properties

cd ${FAST_RTPS_GEN_DIR}
./gradlew assemble && sudo env "PATH=$PATH" ./gradlew install


# 4) Setup ROS2 ws for px4_ros_com & px4_msgs
git clone https://github.com/PX4/px4_ros_com.git ${ROS2_WS_DIR}/src/px4_ros_com
git clone https://github.com/PX4/px4_msgs.git ${ROS2_WS_DIR}/src/px4_msgs

# 5) Install QGroundControl
cd ${APPS_DIR}
# sudo usermod -a -G dialout $USER
sudo apt-get remove modemmanager -y
sudo apt-get install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
# install fuse (ONLY FOR <=20.04)
sudo apt-get install fuse libfuse2

wget https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage
chmod +x ./QGroundControl.AppImage

# 6) Install your source code/pkgs
cd ${HOME_DIR}

echo "Installs took $SECONDS seconds."
