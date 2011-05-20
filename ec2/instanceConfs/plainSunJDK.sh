#!/bin/sh
#
# assuming you're running this as root
# this is for aws Linux AMIs and derivatives; it assumes that
# there's a ec2-user user
#

# vars
JAVA_BASE_URL=http://resources.ohnosequences.com/bin/jdk/x64/latest
JAVA_BIN_FILE=jdk.bin
JAVA_INSTALL_BASE=/opt
JAVA_INSTALL_FOLDER=java
JAVA_INSTALL_PATH=$JAVA_INSTALL_BASE/$JAVA_INSTALL_FOLDER


# create folder and go into
cd $JAVA_INSTALL_BASE
mkdir -p $JAVA_INSTALL_FOLDER
cd $JAVA_INSTALL_FOLDER

# download jdk, make it exec
wget -O $JAVA_BIN_FILE $JAVA_BASE_URL
chmod u+x $JAVA_BIN_FILE

# automated install trick
echo "\n" | ./$JAVA_BIN_FILE 1>/dev/null

# clean stuff
rm $JAVA_BIN_FILE

# get the folder and set JAVA_INSTALL_PATH
JAVA_INSTALL_PATH=$JAVA_INSTALL_PATH/`ls | grep jdk1*`
SET_JAVA_HOME_STRING="export JAVA_HOME="$JAVA_INSTALL_PATH
ADD_JAVA_TO_PATH_STRING="export PATH=\$JAVA_HOME/bin:\$PATH"

# make JAVA_HOME globally available; This should be in terms of JAVA_INSTAL_PATH
echo $SET_JAVA_HOME_STRING | tee -a /etc/environment

# root $JAVA_HOME conf; don't know how sensible is this
echo $SET_JAVA_HOME_STRING | tee -a /root/.bash_profile
echo $ADD_JAVA_TO_PATH_STRING | tee -a /root/.bash_profile
bash -c "source /root/.bash_profile"

# ec2-user $JAVA_HOME conf
echo $SET_JAVA_HOME_STRING | tee -a /home/ec2-user/.bash_profile
echo $ADD_JAVA_TO_PATH_STRING | tee -a /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile

# sanity check:
java -version






