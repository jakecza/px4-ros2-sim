#!/bin/bash
# Installs Fast-DDS/RTPS

set -e

. ./config.bash
. /opt/ros/${ROS2_DISTRO}/setup.bash

#
# Install Java (20.04 -> v13, 22.04 ->v11)
#
sudo apt-get -y --no-install-recommends install ant openjdk-13-jre openjdk-13-jdk libvecmath-java
sudo apt-get -y --no-install-recommends install wget curl
#
# Install Foonathan memory
#
git clone https://github.com/eProsima/foonathan_memory_vendor.git \
  && cd foonathan_memory_vendor \
  && mkdir build && cd build \
  && cmake .. \
  && cmake --build . --target install

#
# Install Gradle (Required to build Fast-RTPS-Gen)
#
wget -q "https://services.gradle.org/distributions/gradle-6.3-rc-4-bin.zip" -O /tmp/gradle-6.3-rc-4-bin.zip \
  && mkdir /opt/gradle \
  && cd /tmp \
  && unzip -d /opt/gradle gradle-6.3-rc-4-bin.zip \
  && echo "export PATH=$PATH:/opt/gradle/gradle-6.3-rc-4/bin" >> ~/.bashrc \
  && source ~/.bashrc \
  && cd $PWD

#
# Install Fast-RTPS 
#
if [ $ROS2_DISTRO == "dashing" ]; then
  # Install Fast-RTPS 1.8.4 (latest supported version)
  git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v1.8.4 /tmp/FastRTPS-1.8.4 \
    && cd /tmp/FastRTPS-1.8.4 \
    && mkdir build && cd build \
    && cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
    && cmake --build . --target install \
    && cd $PWD
elif [ $ROS2_DISTRO == "eloquent" ]; then
  # Install Fast-RTPS 1.9.3 (latest supported version)
  git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v1.9.3 /tmp/FastRTPS-1.9.3 \
    && cd /tmp/FastRTPS-1.9.3 \
    && mkdir build && cd build \
    && cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
    && cmake --build . --target install \
    && cd $PWD
elif [ $ROS2_DISTRO == "foxy" ]; then
  # Install Fast-RTPS 2.0.2 (latest supported version)
  git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v2.0.2 /tmp/FastDDS-2.0.2 \
    && cd /tmp/FastDDS-2.0.2 \
    && mkdir build && cd build \
    && cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
    && cmake --build . --target install \
    && cd $PWD
elif [ $ROS2_DISTRO == "galactic" ]; then
  # Install Fast-RTPS 2.3.1 (later versions might be supported)
  git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v2.3.1 /tmp/FastDDS-2.3.1 \
    && cd /tmp/FastDDS-2.3.1 \
    && mkdir build && cd build \
    && cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
    && cmake --build . --target install \
    && cd $PWD
elif [ $ROS2_DISTRO == "rolling" ]; then
  # Install Fast-RTPS 2.3.1 (later versions might be supported)
  git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v2.3.1 /tmp/FastDDS-2.3.1 \
    && cd /tmp/FastDDS-2.3.1 \
    && mkdir build && cd build \
    && cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
    && cmake --build . --target install \
    && cd $PWD
fi

#
# Install Fast-RTPS-Gen
#
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v1.0.4 /tmp/Fast-RTPS-Gen \
  && cd /tmp/Fast-RTPS-Gen \
  && gradle assemble \
  && sudo cp share/fastrtps/fastrtpsgen.jar /usr/local/share/fastrtps/ \
  && sudo cp scripts/fastrtpsgen /usr/local/bin/ \
  && cd $PWD

#
# Install ROS2 dependencies
#
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo "Updating package lists ..."
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade
echo "Installing ROS2 $ROS2_DISTRO and some dependencies..."

sudo apt-get install -y \
  dirmngr \
  gnupg2 \
  python3-colcon-common-extensions \
  python3-dev \
  ros-$ROS2_DISTRO-desktop \
  ros-$ROS2_DISTRO-eigen3-cmake-module \
  ros-$ROS2_DISTRO-launch-testing-ament-cmake \
  ros-$ROS2_DISTRO-rosidl-generator-dds-idl

# Install Python3 packages needed for testing
curl https://bootstrap.pypa.io/get-pip.py | python3 &&
  python3 -m pip install --upgrade pip \
    setuptools \
    argcomplete \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest \
    pytest-cov \
    pytest-repeat \
    pytest-runner \
    pytest-rerunfailures

# Install Python3 packages for uORB topic generation
python3 -c "import em" || python3 -m pip install --user empy
python3 -c "import genmsg.template_tools" || python3 -m pip install --user pyros-genmsg
python3 -c "import packaging" || python3 -m pip install --user packaging

# Clean residuals
if [ -o clean ]; then
  sudo apt-get -y autoremove &&
    sudo apt-get clean autoclean &&
    sudo rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
fi
