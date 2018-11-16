#!/bin/sh
while getopts "b:e:m:l:" arg
do
    case $arg in 
        b)
        echo $OPTARG
        beginport=$(($OPTARG))
        ;;
        e)
        echo $OPTARG
        endport=$(($OPTARG))
        ;;
        m)
        echo $OPTARG
        ss_manager_port=$(($OPTARG))
        ;;
        l)
        echo $OPTARG
        limit=$(($OPTARG))
        ;;
        ?)
        echo "unkonw argument"
        exit 1
        ;;
    esac
done 
# run 
for ((i=$beginport;i<=$endport;i++))
do 
    tmp_server_port=$i
    echo ${tmp_server_port}
    # sudo ssserver -p 443 -k password -m rc4-md5 --user nobody -d start
    cmd="{\"open\":{\"server_port\":${tmp_server_port},\"password\": \"test\",\"limitup\": ${limit},\"limitdown\": ${limit},\"method\": \"aes-128-cfb\"}}"
    echo -n "${cmd}"  | nc -4u -w1 localhost ${ss_manager_port}
    sleep 0.01s
done 
