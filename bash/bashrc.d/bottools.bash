# Return a properly formatted ROS bot name (i.e. p[0-9]*[_][0-9][0-9][0-9])
bot(){
  if [[ -n "$1" ]]
  then
    raw="$1"
    echo "$raw" | sed s/-/_/
  fi
}

botlog() {
  if [ -n "$1" ]
  then
    ns=$(bot $1)
    use_ns=true
  else
    ns=
    use_ns=false
  fi
  filters=$(rospack find babbage_launch)/resources/base_launch_filters.yaml
  roslaunch util log_aggregator.launch use_ns:=$use_ns ns:=$ns filters:=$filters
}

execlog() {
  if [ -n "$1" ]
  then
    ns=$(bot $1)
    use_ns=true
  else
    ns=
    use_ns=false
  fi
  filters=$(rospack find babbage_executive)/resources/demo_executive_filters.yaml
  roslaunch util log_aggregator.launch use_ns:=$use_ns ns:=$ns filters:=$filters
}

# Get log_aggregator output from the server
# FFFFFU: bugged and gets everything???
servlog() {
  filters=$(rospack find babbage_launch)/resources/server_filters.yaml
  roslaunch util log_aggregator.launch use_ns:=false filters:=$filters
}

# teleop a robot
teleop_pkg=teleop_twist_keyboard
teleop_type=teleop_twist_keyboard.py
teleop() {
  if [[ -n "$1" ]]
  then
    r="$(bot $1)"
  elif [[ -n "$ROBOT" ]]
  then
    r="$ROBOT"
  else
    echo "Specify a robot to teleop."
    return 0
  fi
  ns="/$r"

  if [[ -n "$2" ]]
  then
    name="$2"
  else
    name=${HOSTNAME}_${r}_teleop
  fi

  rosrun $teleop_pkg $teleop_type cmd_vel:=$ns/teleop/cmd_vel __name:=$name
}

# poweroff a robot
powerdown_srv=trigger_power_down
powerdown_opts="timeout: 0"
powerdown() {
  if [[ -n "$1" ]]
  then
    ns="/$(bot $1)"
  elif [[ -n "$ROBOT" ]]
  then
    ns="/$ROBOT"
  else
    echo "Specify a robot to power down."
    return 0
  fi

  calling="rosservice call $ns/$powerdown_srv \"${powerdown_opts}\""
  # rosservice call $ns/$poweroff_srv "$poweroff_opts"
  echo calling \'$calling\'
  rosservice call $ns/$powerdown_srv "${powerdown_opts}"
}

viz_pkg="babbage_launch"
viz_launch="viz.launch"
viz() {
  if [[ -n "$1" ]]
  then
    robots="robots:=$1"
  else
    robots=
  fi
  roslaunch $viz_pkg $viz_launch $robots
}

locbag() {
  if [[ -n "$1" ]]
  then
    r="/$(bot $1)"
    if [[ -n "$2" ]]
    then
      name="--output-name=$2"
    else
      name=''
    fi
    rosbag record $name /tf /map $r/amcl_pose $r/csm/pose $r/imu $r/initialpose $r/joint_states $r/mobile_base_controller/cmd_vel $r/mobile_base_controller/odom $r/move_base/goal $r/odom $r/scan_sparse
  fi
}

