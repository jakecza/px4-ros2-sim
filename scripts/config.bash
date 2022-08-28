#!/bin/bash
# Source this file in other shell scripts to provide global config params

# General
UBUNTU_RELEASE=focal
ROS2_DISTRO=foxy
# ROS_PYTHON_VERSION=3

DOCKER_HUB_PATH=jakecza/px4-ros2-sim:foxy
SIM_CONTAINER_NAME=gazebo-px4-sim
SIM_CONTAINER_USER=root # if no user was created, use 'root'

# Software versions
FAST_DDS_BRANCH=v2.0.2
FAST_RTPS_GEN_BRANCH=v1.0.4
PX4_FIRMWARE_BRANCH=release/1.13

# Container folder structure
HOME_DIR=/root
CLONES_DIR=${HOME_DIR}/clones # storage of general dependencies
APPS_DIR=${HOME_DIR}/apps # where runnable apps are placed (i.e QGroundControl)
ROS2_WS_DIR=${HOME_DIR}/ros2_ws # seperate ws for building ROS dependencies

FAST_DDS_DIR=${CLONES_DIR}/Fast-DDS
FAST_RTPS_GEN_DIR=${CLONES_DIR}/Fast-DDS-Gen

LINK_PKG_TO=${HOME_DIR}/px4_ros2_sim # dir that the pkg will be mnted to
PX4_FIRMWARE_DIR=${HOME_DIR}/PX4-Autopilot # where to clone the PX4-Autopilot repo
PX4_SITL_GAZEBO_DIR=${ROS2_WS_DIR}/src/PX4-SITL_gazebo # where to clone the PX4-SITL_gazebo repo
PX4_MSGS_DIR=${ROS2_WS_DIR}/src/px4_msgs # where to clone the px4_msgs repo
PX4_ROS_COM_DIR=${ROS2_WS_DIR}/src/px4_ros_com # where to clone the px4_ros_com repo
