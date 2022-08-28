# Ubuntu 20.04LTS, Gazebo 11, PX4, ROS2 Foxy Simulation container.

# Start with base ROS2 image with Gazebo + Nvidia
FROM jakecza/ros2:foxy-full-sim

# Copy scripts directory into container.
COPY ./scripts /scripts

# Install & Build (as root)
# Run one script at a time to allow the image to be built in layers
RUN cd /scripts && bash -x ./install.bash
RUN cd /scripts && bash -x ./build.bash