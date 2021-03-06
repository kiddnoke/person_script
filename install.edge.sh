#!/bin/
cd ~
# epel-release
yum install epel-release -y 
yum install wget curl -y 
# install nodejs 
cd ~
node_version=$(node --version)
if [ $node_version != 'v10.13.0'];then
    wget https://nodejs.org/dist/v10.13.0/node-v10.13.0-linux-x64.tar.xz
    xz -d node-v10.13.0-linux-x64.tar.xz 
    tar xvf node-v10.13.0-linux-x64.tar
    cd node-v10.13.0-linux-x64
    cp -r * /usr
fi
 

# install git 
cd ~
git_version=$(git --version)
if [ $git_version == 'git version 2.*'] ;then
    yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker -y
    wget https://www.kernel.org/pub/software/scm/git/git-2.13.0.tar.gz   
    tar -zxvf git-2.13.0.tar.gz 
    cd git-2.13.0
    ./configure prefix=/usr/local/
    make -j8 && make install 
fi 

# pull VpnEdge
cd ~
rm -rf VpnEdge 
git clone https://github.com/kiddnoke/VpnEdge.git
cd VpnEdge
git checkout v1.0.2
python setup.py install --record install.txt 
cat install.txt | xargs rm -f 
python setup.py install --record install.txt 
cd ~ && rm -rf VpnEdge
# pull VpnNodeMgr 
cd ~ 
git clone https://github.com/kiddnoke/NodeMgrAgent.git
cd NodeMgrAgent
git checkout v1.0.2
npm i 
# start exec
cd ~
pm2 kill 
ssmanger --manager-address 127.0.0.1:8001 -d start 
cd NodeMgrAgent 
host=$1
state=$2
area=$3
filename='pm2.config.js'
sed -i "5s/localhost/${host}/g" $filename 
sed -i "5s/State/${state}/g" $filename 
sed -i "5s/Area/${area}/g" $filename 
npm run pm2start 