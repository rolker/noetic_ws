# Installing ROS Noetic from source on modern Ubuntu

rosinstall_generator desktop --rosdistro noetic --deps  > noetic-desktop.rosinstall

./src/catkin/bin/catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python3

