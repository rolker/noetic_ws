#!/bin/bash

# Define color shortcuts

# Reset
Color_Off='\033[0m'       # Text Reset

Color_On='\033[1;32m\033[40m' 

set -x

echo -e "\n${Color_On}Install initial dependencies${Color_Off}\n"

sudo apt install python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool build-essential

echo -e "\n${Color_On}Initialize and update rosdep${Color_Off}\n"


sudo rosdep init

rosdep update

echo -e "\n${Color_On}Generate list of desktop packages${Color_Off}\n"

rosinstall_generator desktop --rosdistro noetic --deps > noetic.rosinstall

echo -e "\n${Color_On}Fetch desktop packages${Color_Off}\n"

mkdir ../src

vcs import --input noetic.rosinstall ../src

echo -e "\n${Color_On}Fetch patched packages${Color_Off}\n"

vcs import --force --input patches.rosinstall ../src

echo -e "\n${Color_On}Install ROS dependencies${Color_Off}\n"

rosdep install --from-paths ../src -i -r --rosdistro noetic -y

cd .. || exit

echo -e "\n${Color_On}Build ROS${Color_Off}\n"

./src/catkin/bin/catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python3
