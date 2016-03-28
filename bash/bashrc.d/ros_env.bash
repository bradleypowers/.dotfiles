# Various functions for messing with ROS env (ROS_MASTER_URI and ROS_NAMESPACE)
ROSPORT=11311
rmu() {
  if [[ -n "$1" ]]
  then
    if [[ -n "$2" ]]
    then
      port=$2
    else
      port=$ROSPORT
    fi
    echo "http://$1:$port"
  else
    echo ""
  fi
}

# Convert the input into proper rosgraph names (i.e. underscores instead of dashes, etc.)
rosgraph_name() {
  if [[ -n "$1" ]]
  then
    sed s/-/_/g <<< $1
  fi
}

function ermu() {
  if [ -n "$1" ]
  then
    if [[ "$1" = "-l" ]]
    then
      host=localhost
    elif [[ "$1" = "-h" ]]
    then
      host=$HOSTNAME
    else
      host="$1"
    fi
    if [[ -n "$2" ]]
    then
      port="$2"
    else
      port=""
    fi
    export ROS_MASTER_URI=$(rmu $host $port)
  fi;
  echo ROS_MASTER_URI=$ROS_MASTER_URI
}


ermul()
{
  ermu -l $@
}

ermuh()
{
  ermu -h $@
}

# ermu persistent
ermupf=~/.ermup
ermup()
{
  if [ -n "$1" ]
  then
    host=$1
    if [[ -n "$2" ]]
    then
      port=$2
    else
      port=""
    fi
    echo $host $port > $ermupf
  fi
  if [[ -f $ermupf ]]
  then
    ermu $(cat $ermupf)
  else
    echo "Persistent ROS_MASTER_URI file \"$ermupf\" does not exist."
    ermu
  fi
}

ermup_old()
{
  if [ -n "$1" ]
  then
    ermu $1
    echo $1 > ~/.ermup
  else
    if [ -f ~/.ermup ]
    then
      ermu $(cat ~/.ermup)
    fi
  fi
}


c_rmu_local='\033[01;32m'
c_rmu_remote='\033[01;36m'
ermu_color ()
{
  if [[ "$ROS_MASTER_URI" == "$(rmu localhost)" ]] || [[ "$ROS_MASTER_URI" == "$(rmu $HOSTNAME)" ]]
  then
    c_ermu=$c_rmu_local
  else
    c_ermu=$c_rmu_remote
  fi
  if [[ "$color_prompt" = yes ]]
  then
    echo "$c_ermu"
  else
    echo ""
  fi
}

function erns() {
  if [ -n "$1" ]
    then
    if [ "$1" = "-c" ]
    then
      ns=""
    else
      ns=$(rosgraph_name "$1")
    fi
    export ROS_NAMESPACE="$ns"
  fi
  echo ROS_NAMESPACE=$ROS_NAMESPACE
}

