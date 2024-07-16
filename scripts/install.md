# Install instructions

This is based on: https://wiki.ros.org/noetic/Installation/Source

    sudo apt install python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool build-essential


    sudo rosdep init

    rosdep update


    rosinstall_generator desktop_full --rosdistro noetic --deps > noetic.rosinstall

    mkdir ../src

    vcs import --input noetic.rosinstall ../src


    rosdep install --from-paths ../src --ignore-packages-from-source --rosdistro noetic -y

    cd ../src

    ./src/catkin/bin/catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python3
