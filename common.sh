###
 # @Author       : facsert
 # @Date         : 2023-08-09 17:59:14
 # @LastEditTime : 2023-12-13 22:46:37
 # @Description  : edit description
### 


# 打印函数
# logger "info"  "info log"
# logger "error" "error log"
function logger() {
    local type=${1:-"info"}
    local content=$2
    local now=$(date +"%Y/%m/%d %H:%M:%S")

    case $type in
      "info") 
        printf "[INFO ][%s]: %-80s \n" "$now" "$content"
        ;;
      "error")
        printf "\33[33m[ERROR][%s]: %-80s \33[0m \n" "$now" "$content"
        ;;
      *) 
        echo "error parameter: $type"
        exit 1
        ;;
    esac
}

# 打印结果, true->pass false->fail exit->exit(错误并退出)
# display "true"   "pass msg"
# display "false"  "fail msg"
# display "exit" "fail msg and exit"
function display() {
    local type=${1:-"true"}
    local content=$2
    local now=$(date +"%Y/%m/%d %H:%M:%S")
    
    case $type in
      "true") 
        printf "\33[32m[INFO ][%s]: %-80s  [PASS] \33[0m \n" "$now" "$content"
        ;;
      "false")
        printf "\33[31m[ERROR][%s]: %-80s  [FAIL] \33[0m \n" "$now" "$content"
        ;;
      "exit")
        printf "\33[31m[ERROR][%s]: %-80s  [EXIT] \33[0m \n" "$now" "$content"
        exit 1
        ;;
      *) 
        printf "\33[31m[ERROR][%s]: %-80s  [EXIT]\33[0m \n" "$now" "error type:$type, $content"
        exit 1
        ;;
    esac
}

# 标题打印
# title 0 "level 0 title"
function title() {
    local level=${1:-3}
    local content=$2
    
    case $level in
      0)
        local side="####################"
        local next="\n\n"
        ;;
      1)
        local side="===================="
        local next="\n"
        ;;
      2) 
        side="********************"
        local next=""
        ;;
      3) 
        local side="--------------------"
        local next=""
        ;;
      *) display "error level" "exit"
    esac

    echo -e "$next$side$side $content $side$side"
}


# 替换字符串
function replace() {
  local string=$1
  local src=$2
  local dst=$3
  local once=${4:-false}

  [[ $once == "true" ]] && local all="" || local all="g"
  echo -e $string | sed -e "s/${src}/${dst}/${all}"
  [[ $? -eq 0 ]] && return 0 || return 1
}

# 取出字符串中匹配的内容
function search() {
  local string=$1
  local regex=$2

  echo -e $string | grep -oP "$regex"
  [[ $? -eq 0 ]] && return 0 || return 1
}


# 字符串分割
function split() {
    local string=$1
    local separator=$2

    echo -e $string | tr "$separator" " "
}

# 字符串拼接
function join() {
    local string=$1
    local separator=$2

    echo -e $string | tr " " "$separator"
}

usage=$(cat <<EOF
  -h/--help      show help   \n
  -d/--dir DIR   set workdir \n
  --host HOST    set host    \n
EOF
)

logger "info" "common.sh loaded"
logger "error" "error log"

declare -a params
while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        echo -e $usage
        exit 0
        ;;
      -d|--dir)
        logger "info" "Set workdir to $2"
        WORKDIR=$2
        shift 2
        ;;
      --host)
        logger "info" "Set host to $2"
        HOST=$2
        shift 2
        ;;
      *)
        echo "param $1"
        params+=($1)
        shift
        ;;
    esac
done

echo "params: ${params[@]}"
for param in ${params[@]}; do
    case $param in
      -t|--test)
        logger "info" "Set test"
        shift
        ;;
      -s|--src)
        logger "info" "Set src"
        shift
        ;;
      *)
        display "exit" "error param $param"
        shift
        ;;
    esac
done
