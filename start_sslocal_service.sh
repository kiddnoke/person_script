#!/bin/sh
beginport=0
endport=0
while getopts "h:b:e:" arg
do
    case $arg in 
        h)
        echo host = $OPTARG
        host=$OPTARG
        ;;
        b)
        echo $OPTARG
        beginport=$(($OPTARG))
        ;;
        e)
        echo $OPTARG
        endport=$(($OPTARG))
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
    let tmp_server_port=${i}
    let tmp_local_port=${i}
    ss-local -s ${host} -p ${tmp_server_port} -m aes-128-cfb -k test -l  ${tmp_local_port}  -f /tmp/sslocal-${tmp_local_port}.pid
done
