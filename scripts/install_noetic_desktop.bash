#!/bin/bash

# Loosely based on https://wiki.ros.org/noetic/Installation/Source

# Define color shortcuts

# Reset
Color_Off='\033[0m'       # Text Reset

Color_On='\033[1;32m\033[40m' 

set -x

echo -e "\n${Color_On}Make sure we are working from the scripts directory${Color_Off}\n"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" || exit

# gen package list

rosinstall_generator desktop --rosdistro noetic --deps > noetic.yaml

# import desktop packages

echo -e "\n${Color_On}Fetch desktop packages${Color_Off}\n"

rm -rf ../desktop_ws/src
mkdir -p ../desktop_ws/src

vcs import --force --input noetic.yaml ../desktop_ws/src

echo -e "\n${Color_On}Fetch patched packages${Color_Off}\n"

vcs import --force --input patches.yaml ../desktop_ws/src

# rosdep

echo -e "\n${Color_On}Install ROS dependencies${Color_Off}\n"

rosdep install --from-paths ../desktop_ws/src -i -r --rosdistro noetic -y

cd ../desktop_ws/ || exit

# catkin_make_isolated

echo -e "\n${Color_On}Build ROS${Color_Off}\n"

sudo mkdir -p /opt/ros/noetic
sudo chown $USER /opt/ros/noetic

ROS_PYTHON_VERSION=3 ./src/catkin/bin/catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python3 --install --install-space /opt/ros/noetic

source install_isolated/setup.bash

