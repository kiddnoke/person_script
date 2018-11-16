#!/bin/sh
while getopts "h:b:e:" arg
do
    case $arg in 
        b)
        echo beginport= $OPTARG
        beginport=$(($OPTARG))
        ;;
        e)
        echo endport= $OPTARG
        endport=$(($OPTARG))
        ;;
        ?)
        echo "unkonw argument"
        exit 1
        ;;
    esac
done 

function getRandom(){
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000)) #增加一个10位的数再求余
    echo $(($num%$max+$min))
}

resource=("http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin" \
"http://speedtest.newark.linode.com/100MB-newark.bin" \
"http://speedtest.atlanta.linode.com/100MB-atlanta.bin" \
"http://speedtest.dallas.linode.com/100MB-dallas.bin" \
"http://speedtest.fremont.linode.com/100MB-fremont.bin" \
)
resource_length=${#resource[@]}
function asyncrequest()
{
    port=$(($1))
    resource_index=$(getRandom 0 ${resource_length}-1)
    request_address=${resource[resource_index]}
    let local_port=${port}
    echo curl --socks5 localhost:${local_port} "${request_address}"
    curl -s --socks5 localhost:${local_port} "${request_address}" > /dev/null &
}
function request()
{
    port=$(($1))
    resource_index=$(getRandom 0 ${resource_length})
    request_address=${resource[resource_index]}
    let local_port=${port}
    # echo curl --socks5 localhost:${local_port} "${request_address}"
    curl -s --socks5 localhost:${local_port} "${request_address}" > /dev/null  
}

for ((i=${beginport};i<${endport};i++))
do
    asyncrequest ${i}
done
