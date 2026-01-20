#!/bin/bash
export PS4='+ $(date "+%H:%M:%S.%3N")  '
set -x
echo " " > /tmp/run_barrier
kill -USR1 $(pgrep joint_velocity_example_controller)
#rosservice call /joint_velocity_example_controller/gripper_release

