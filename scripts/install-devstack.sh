#!/bin/bash
#set +o
#set -u
LOCALRC=$1
# using  douban source
if [ ! -e $HOME/.pip ];then
	mkdir $HOME/.pip
fi

#cat <<EOF>$HOME/.pip/pip.conf
#[global]
#index-url = http://pypi.douban.com/simple/
#EOF
if [ -e ~/.bashrc ] ; then
	cat << EOF >> ~/.bashrc
	#export http_proxy=http://web-proxy.corp.hp.com:8080
	#export http_proxy=http://web-proxy.corp.hp.com:8080
	export http_proxy=http://proxy.houston.hp.com:8080
	export https_proxy=https://proxy.houston.hp.com:8080

EOF
	source ~/.bashrc
	echo "set proxy:$http_proxy"
fi

cat << END >$HOME/.pip/pip.conf
[global]
#index-url = http://pypi.douban.com/simple/
END

# replace source.list
#sed -i.bak s/us/cn/g /etc/apt/sources.list


# set proxy
IS_PROXY_SET=`env | grep -i proxy`
if [[ -z $IS_PROXY_SET  ]];then
        echo "set proxy..."
	export http_proxy=http://proxy.houston.hp.com:8080
	export https_proxy=https://proxy.houston.hp.com:8080
	# set proxy for apt.conf
        #cat << APT >/etc/apt/apt.conf
#Acquire::http::Proxy "http://web-proxy.corp.hp.com:8080/";
#APT
        # set proxy
	echo 'Acquire::http::Proxy "http://proxy.houston.hp.com:8080";' \
        | sudo tee -a /etc/apt/apt.conf.d/00aptitude
fi

# do update
echo "==>updating..."
#apt-get update -y >/dev/nul
sudo apt-get update -qqy 

echo "==>installing git ..."
# install git
sudo apt-get install -qqy git  

echo "clone devstack..."
#clone devstack
if [ ! -e devstack ]; then
	#git clone -q https://github.com/openstack-dev/devstack.git
	git clone -q https://github.com/ilivessevili/devstack.git
fi
echo 'devstack is already exits skip'
echo "copy $LOCALRC..."
#copy localrc from sync folder
#if [ -e /vagrant_data/localrc ]; then
    #cp  /vagrant_data$LOCALRC /home/vagrant/devstack/localrc
#fi
if [ ! -e /home/vagrant/devstack ]; then
   echo 'devstack folder not exist! stop!!'
   exit -1
fi
cp  -v /vagrant_data/$LOCALRC /home/vagrant/devstack/local.conf
# monkey patch the devstack
cp  -v "/vagrant/scripts/functions-common" /home/vagrant/devstack

if [ -e /home/vagrant/devstack ]; then
	cd  /home/vagrant/devstack
	#export http_proxy=http://web-proxy.corp.hp.com:8080
        #export https_proxy=https://web-proxy.corp.hp.com:8080
     ./unstack.sh && ./stack.sh
     if [ $? == 0 ]; then
       echo "*****************************"
       echo " install devstack done! "
       echo "*****************************"
       exit 0
     fi
      

     echo "########################################"
     echo "error install devstack!"
     echo "########################################"
     
fi
