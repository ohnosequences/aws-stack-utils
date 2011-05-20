#!/bin/sh

# this is the script that gets bundled on the AMI, runs on startup.
# It will download and execute what you pass in as user-data. Hacky, but it works!
# 
set -e -x
# vars
instance_data_url=http://169.254.169.254/latest
user_data_url=$instance_data_url/user-data
base_url=http://resources.ohnosequences.com/ec2/instance-conf

# where conf resides
base_conf_folder=/opt
conf_folder=$base_conf_folder/conf

# create stuff
mkdir -p $conf_folder
chown ec2-user:ec2-user $conf_folder

# get provided user data
cd $conf_folder
curl -s --output address.tmp $user_data_url 
wget -O selfConf.sh `cat address.tmp`
cat address.tmp > instance_conf_type
rm address.tmp

# set perms and execute it 
chmod u+x selfConf.sh
source ./selfConf.sh &>selfConf.log

# set perms for ec2-user
chown -R ec2-user:ec2-user $conf_folder/*



