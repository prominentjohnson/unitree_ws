# Unitree Workspace (with Git Submodules)

This repository uses Git submodules to include several dependent repositories.

## Submodules

unitree_ros_ws/src/unitree_ros → your fork of unitree_ros

z1_controller → your fork of z1_controller

z1_sdk → your fork of z1_sdk

## How to clone with submodules

```bash
git clone --recurse-submodules git@github.com:prominentjohnson/unitree_ws.git
```

If you already cloned without submodules

```bash
cd unitree_ws
git submodule update --init --recursive
```

## How to run ROS simulation

### Prerequest

The simulation can be run on ROS melodic or neotic. Therefore, you should install Ubuntu 18.04 or Ubuntu 20.04 respectively. Make sure ROS is installed.

### Set ROS workspace

```bash
cd unitree_ros_ws
catkin_make
source devel/setup.bash
```

### Run launch file

Run
```bash
roslaunch unitree_gazebo z1.launch UnitreeGripperYN:=true
```
to start simulation with the gripper. Set UnitreeGripperYN to false to run simulation without gripper.

If successfully configured, the simulation interface of Gazebo will be displayed.

## How to Enable Control using z1_controller

In some of the old document provided by Unitree, they switch between
```bash
set(COMMUNICATION UDP)             #UDP
set(COMMUNICATION ROS)             #ROS
```
in the CMakeLists.txt to enable control for the real machine or simulation. However this is not available in the current code because there's no such lines in the CMakeLists.txt.

To control the z1 robot, the first step is to build the targets:
```bash
cd z1_controller
mkdir build
cd build
cmake ..
make
```
Then if you want to control the robot in the simulation, execute `./sim_ctrl`.
Instead, if you want to control the real machine, execute `./z1_ctrl`.
If you want to use keyboard control, execute`./z1_ctrl k`for the real machine, and`./sim_ctrl k` for the simulation.

## How to use z1_sdk

First, build the targets:
```bash
cd z1_sdk
mkdir build
cd build
cmake ..
make
```
In the simulation, after executing
```bash
./sim_ctrl
```
z1_controller tries to communicate with z1_sdk. Now by executing
```bash
./highcmd_basic
```
The robot will start to perform a demo(dance) in the simulation.
Simmilarly, if you want the robot to dance in the real world. Combine `./z1_ctrl` and `./highcmd_basic`.

## How to communicate with the robot arm
```bash
sudo ifconfig enp0s31f6 down
sudo ifconfig enp0s31f6 192.168.123.7/24
sudo ifconfig enp0s31f6 up
```
and check if the connection is successful:
```bash
ping 192.168.123.110
```


## How to use python binding
```bash
export LD_LIBRARY_PATH=/home/kris/workspaces/unitree_ws/z1_sdk/lib:$LD_LIBRARY_PATH
```

## Guide for conducting double robots experiment

### Common Steps
If the PC just starts, create a temporary fifo file in the tmp folder
```bash
mkfifo /tmp/run_barrier
```
If the PC is on, check wether the file already exists, or simply first delete the file and than create
```bash
sudo rm /tmp/run_barrier
mkfifo /tmp/run_barrier
```

### Untree Z1
Open four terminals respectively in unitree_ws, unitress_ros_ws, z1_controller, z1_sdk.
In z1_controller:
```bash
cd ~/workspace/unitree_ws/z1_controller
cmake ..
make
./z1_ctrl #./sim_ctrl for simulation
```
In z1_sdk:
```bash
cd ~/workspace/unitree_ws/z1_sdk
cmake ..
make
./lowcmd_development
```
In unitree_ros_ws:
If you want to run ros simulation for testing:
```bash
cd ~/workspace/unitree_ws/unitree_ros_ws
source devel/setup.bash
roslaunch unitree_gazebo z1.launch UnitreeGripperYN:=true
```
In unitree_ws:
Configure the ip address
```bash
sudo ifconfig enp0s31f6 down
sudo ifconfig enp0s31f6 192.168.123.7/24
sudo ifconfig enp0s31f6 up
```
and check if the connection is successful:
```bash
ping 192.168.123.110
```
After both the Z1 and Franka move to the initial position and wait
```bash
cd ~/workspace/unitree_ws/
./go.sh
```

### Franka Panda
Switch on the robot and wait until the yellow light is continuous. Connect the Ethernet wire to your PC. Configure your Ethernet IP address to ```192.168.3.10``` and the netmask to ```255.255.255.0```. 
Open google chrome browser and visit ```https://192.168.3.108/```. If usrname and password is required, enter usrname: franka, password: frankaRSI
After logging in, unlock the robot by clicking a button in the right middle of the UI. Keep the safety button in your hand. press it to lock the robot and the white light should be on. Spin it clockwise to unlock the safety button, the light should turn blue and the robot can be moved. On the top right, find a button to activate FCI so that it can be controlled by your code.
Then you should be able to run your code. Open three terminals, one in libfranka/build/examples and two in franka_ros_ws.
In libfranka, execute
```bash
cd ~/workspace/franka_ws/libfranka/build/examples
./communication_test 192.168.3.108
```
to test communication with the robot, and the robot should be able to move to the zero position.
In franka_ros_ws 1, do
```bash
cd ~/workspace/franka_ws/franka_ros_ws
catkin_make
```
to compile the ros workspace whenever you did some changes in the code.
In franka_ros_ws_2, run the controller by
```bash
cd ~/workspace/franka_ws/franka_ros_ws
source devel/setup.bash
roslaunch franka_example_controllers joint_velocity_example_controller.launch robot_ip:=192.168.3.108

# To test the code in simulation:
source devel/setup.bash
roslaunch franka_gazebo panda.launch controller:=joint_velocity_example_controller rviz:=true
```


TODO next step: 
1. print a new catcher without the holder.
2. Try the robust trajectory.