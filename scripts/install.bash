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

./install_initial_dependencies.bash
./install_noetic_desktop.bash
./install_extras.bash
