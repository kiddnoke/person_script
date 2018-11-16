#!/bin/sh
filename='pm2.config.js'
host=$1
state=$2
area=$3
sed -i "5s/localhost/${host}/g" $filename 
sed -i "5s/State/${state}/g" $filename 
sed -i "5s/Area/${area}/g" $filename 