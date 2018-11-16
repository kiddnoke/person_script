#!/bin/
cd ~
# epel-release
yum install epel-release -y 
yum install wget curl -y 
# install nodejs 
wget https://nodejs.org/dist/v10.13.0/node-v10.13.0-linux-x64.tar.xz
xz -d node-v10.13.0-linux-x64.tar.xz 
tar xvf node-v10.13.0-linux-x64.tar
cd node-v10.13.0-linux-x64
cp -r * /usr
 
# install git 
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker -y
wget https://www.kernel.org/pub/software/scm/git/git-2.13.0.tar.gz   
tar -zxvf git-2.13.0.tar.gz 
cd git-2.13.0
./configure prefix=/usr/local/
make -j8 && make install 

# pull VpnEdge
ssmanger -d stop 
cd ~
rm -rf VpnEdge 
git clone https://github.com/kiddnoke/VpnEdge.git
cd VpnEdge
git checkout -b multithread origin/multithread
python setup.py install --record install.txt 
cat install.txt | xargs rm -f 
python setup.py install --record install.txt 
ssmanager --manager-address 127.0.0.1:8001 -d start 

# pull VpnNodeMgr 
cd ~ 
pm2 kill 
git clone https://github.com/kiddnoke/NodeMgrAgent.git
cd NodeMgrAgent
git checkout -b cluster_mode origin/cluster_mode
npm i 
pm2 start pm2.config.js 

vim ~/.bashrc 
export PATH=$PATH:/usr/local/node-v10.13.0-linux-x64/bin/
export AGENTARGS="-H 47.74.217.175  -S SG -A 1"

source ~/.bashrc 

