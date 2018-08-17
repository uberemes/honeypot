#!/bin/sh
cowrie install:
source https://github.com/micheloosterhof/cowrie/blob/master/INSTALL.md

sudo apt update && sudo apt upgrade -y
sudo apt update && sudo apt install git python-virtualenv libssl-dev libffi-dev build-essential libpython-dev python2.7-minimal authbind supervisor -y

sudo adduser --disabled-password cowrie
sudo su - cowrie

git clone http://github.com/micheloosterhof/cowrie && cd cowrie

virtualenv --python=python3 cowrie-env
virtualenv --python=python2 cowrie-env

source cowrie-env/bin/activate
pip install --upgrade pip
pip install --upgrade -r requirements.txt


### in new terminal as root ###
# config file
sudo cp /home/cowrie/cowrie/etc/cowrie.cfg.dist /home/cowrie/cowrie/etc/cowrie.cfg

cd /home/cowrie/cowrie/data
sudo ssh-keygen -t dsa -b 1024 -f ssh_host_dsa_key

## Switch SSH (management port to different port example 1234)
sudo nano /etc/ssh/sshd_config
# port 22
-> port 1234


touch /etc/authbind/byport/22
chown cowrie /etc/authbind/byport/22
chmod 777 /etc/authbind/byport/22


sudo nano /home/cowrie/cowrie/etc/cowrie.cfg
#change hostname


sudo nano /etc/supervisor/conf.d/cowrie.conf
##### ADD #####
[program:cowrie]
command=/home/cowrie/cowrie/bin/cowrie start
directory=/home/cowrie/cowrie/
user=cowrie
autorestart=true
redirect_stderr=true
################

sudo nano /home/cowrie/cowrie/bin/cowrie
# DAEMONIZE=""
-> DAEMONIZE="-n"

#### test ####
[ssh]
listen_endpoints = tcp:22:interface=0.0.0.0
or
# forwards traffic on port 22 -> 2222
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
sudo apt-get install iptables-persistent
# save iptables later state
sudo netfilter-persistent save
#### test ####




##################################################################
##################################################################
###### Default install ###########################################
##################################################################
##################################################################





#### START ####
cd /home/cowrie/cowrie
source cowrie-env/bin/activate
/home/cowrie/cowrie/bin/cowrie start