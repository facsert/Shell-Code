###
 # @Author       : facsert
 # @Date         : 2023-08-09 17:59:14
 # @LastEditTime : 2023-08-09 18:00:35
 # @Description  : edit description
### 


# 打印函数
function logger() {
    local type=${1:-"info"}
    local content=$2
    local now=$(date +"%Y/%m/%d %H:%M:%S")

    case $type in
      "info") 
        printf "[INFO ][%s]: %-80s \n" "$now" "$content"
        ;;
      "error")
        printf "\33[33m[ERROR][%s]: %-80s \33[37m \n" "$now" "$content"
        ;;
      *) 
        echo -e "error parameter: $type"
        exit 1
        ;;
    esac
}

# 打印结果, true->pass false->fail exit->exit(错误并退出)
function display() {
    local type=${1:-"true"}
    local content=$2
    local now=$(date +"%Y/%m/%d %H:%M:%S")
    
    case $type in
      "true") 
        printf "\n\33[32m[INFO ][%s]: %-80s  [PASS] \33[37m \n" "$now" "$content"
        ;;
      "false")
        printf "\n\33[31m[ERROR][%s]: %-80s  [FAIL] \33[37m \n" "$now" "$content"
        ;;
      "exit")
        printf "\n\33[31m[ERROR][%s]: %-80s  [EXIT] \33[37m \n" "$now" "$content"
        exit 1
        ;;
      *) 
        echo -e "\33[31merror parameter: $type \33[37m;content: $content"
        exit 1
        ;;
    esac
}

# 标题打印
function title() {
    local level=${1:-3}
    local content=$2
    
    case $level in
      0) local side="####################"
         local next="\n\n"
        ;;
      1) local side="===================="
         local next="\n"
        ;;
      2) local side="********************"
         local next=""
        ;;
      3) local side="--------------------"
         local next=""
        ;;
      *) display "error level" "exit"
    esac

    echo -e "$next$side$side $content $side$side"
}



declare -a params
while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        usage
        exit 0
        ;;
      -d|--dir)
        logger "info" "Set workdir to $2"
        WORKDIR=$2
        shift 2
        ;;
      --host)
        logger "info" "Set host to $2"
        GPB_HOST=$2
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


