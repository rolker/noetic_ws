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

# extras

echo -e "\n${Color_On}Fetch extra packages${Color_Off}\n"

rm -rf ../extras_ws/src
mkdir -p ../extras_ws/src

vcs import --force --input extras.yaml ../extras_ws/src

touch ../extras_ws/src/ixblue_ins_stdbin_driver/ixblue_ins_driver/CATKIN_IGNORE


# rosdep

echo -e "\n${Color_On}Install ROS dependencies for extras${Color_Off}\n"

source /opt/ros/noetic/setup.bash

rosdep install --from-paths ../extras_ws/src -i -r --rosdistro noetic -y

cd ../extras_ws || exit

# catkin_make_isolated

echo -e "\n${Color_On}Build ROS extras${Color_Off}\n"

ROS_PYTHON_VERSION=3 catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python3 --install --install-space /opt/ros/noetic
