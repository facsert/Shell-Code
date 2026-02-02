
CURRENT_DIR=$(pwd)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
START_SERVER="nohup python main.py >/dev/null 2>&1 &"

# 拉起服务
function StartProcess() {
    cd $SCRIPT_DIR
    $START_SERVER
    local pid=$!
    ps -aux | grep -v grep | grep $pid >/dev/null 2>&1
    echo $pid > pid
    return 0
}

# 关闭服务
function KillProcess() {
    cd $SCRIPT_DIR
    if [[ ! -f pid ]]; then
        echo -e "\033[31mpid not exists \033[0m"
        return 1
    fi
    local pid=$(cat pid)
    if [[ -z $pid ]]; then
        echo -e "\033[31mpid is empty \033[0m"
        return 1
    fi
    
    kill -15 $pid >/dev/null 2>&1
    rm pid
    return 0
}

# 检查服务
function CheckProcess() {
    cd $SCRIPT_DIR
    if [[ ! -f pid ]]; then
        echo -e "\033[31mpid not exists \033[0m"
        return 1
    fi
    local pid=$(cat pid)
    if [[ -z $pid ]]; then
        echo -e "\033[31mpid is empty \033[0m"
        return 1
    fi

    ps -aux | grep -v grep | grep $pid
    if [[ $? -ne 0 ]]; then 
        echo -e "\033[31mProcess is not running\033[0m"
        return 1
    fi
    echo -e "\033[32mProcess is running\033[0m" 
    return 0
}

function BuildImage() {
      local curr_time=$(date +"%Y%m%d_%H%M%S")
      echo "TAG=$curr_time" > .env
      docker compose build
      if [[ $? -ne 0 ]]; then
          echo -e "\033[31mbuild docker image failed \033[0m"
          return 1
      fi
      
      echo -e "\033[32mbuild images success\033[0m" 
      docker images | egrep "$curr_time|REPOSITORY"
}

usage=$(cat <<EOF
    -h/--help      show help           \n
    --build        build docker images \n
    --restart      restart service     \n
    --kill         close service       \n
    --check        check service alive \n
EOF
)

declare -a params
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo -e $usage
            exit 0
            ;;
        --build)
            BuildImage
            exit
            ;;
        --restart)
            cd $SCRIPT_DIR
            KillProcess
            StartProcess
            CheckProcess
            cd $CURRENT_DIR
            exit
            ;;
        --kill)
            cd $SCRIPT_DIR
            KillProcess
            CheckProcess
            cd $CURRENT_DIR
            exit
            ;;
        --check)
            cd $SCRIPT_DIR
            CheckProcess
            cd $CURRENT_DIR
            exit
            ;;
        *)
            echo "param $1"
            params+=($1)
            shift
            ;;
    esac
done
