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


echo -e "\n${Color_On}Add ROS deb source${Color_Off}\n"

# To get some of the non ROS-distro specific ros tools
# From https://docs.ros.org/en/rolling/Installation/Alternatives/Ubuntu-Development-Setup.html

sudo apt install software-properties-common
sudo add-apt-repository -y universe

sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# initial deps

echo -e "\n${Color_On}Update packages list${Color_Off}\n"

sudo apt update

echo -e "\n${Color_On}Install initial dependencies${Color_Off}\n"

sudo apt install -y python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool build-essential

# rosdep

echo -e "\n${Color_On}Initialize and update rosdep${Color_Off}\n"

sudo rosdep init

rosdep update

echo -e "\n${Color_On}Generate list of desktop packages${Color_Off}\n"

# gen package list

rosinstall_generator desktop --rosdistro noetic --deps > noetic.yaml

# import packages

echo -e "\n${Color_On}Fetch desktop packages${Color_Off}\n"

rm -rf ../src
mkdir ../src

vcs import --force --input noetic.yaml ../src

echo -e "\n${Color_On}Fetch extra packages${Color_Off}\n"

vcs import --force --input extras.yaml ../src

touch ../src/ixblue_ins_stdbin_driver/ixblue_ins_driver/CATKIN_IGNORE

echo -e "\n${Color_On}Fetch patched packages${Color_Off}\n"

vcs import --force --input patches.yaml ../src

# rosdep

echo -e "\n${Color_On}Install ROS dependencies${Color_Off}\n"

rosdep install --from-paths ../src -i -r --rosdistro noetic -y

cd .. || exit

# catkin_make_isolated

echo -e "\n${Color_On}Build ROS${Color_Off}\n"

ROS_PYTHON_VERSION=3 ./src/catkin/bin/catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python3
