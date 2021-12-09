#!/bin/bash

#=======================================
# INSTALL TIBCO RENDEZVOUS
#=======================================
rpm -ivh /install/TIB_rv_8.5.1_linux_x86_64.rpm

#=======================================
# INSTALL TIBCO FTL
#=======================================
unzip -j /install/TIB_ftl_6.6.1_linux_x86_64.zip TIB_ftl_6.6.1/rpm/* -d /tmp/tibco-ftl
yum install -y /tmp/tibco-ftl/*.rpm
$FTL_HOME/scripts/post_install/*_install.sh

#=======================================
# INSTALL TIBCO EMS 
#=======================================
unzip -j /install/TIB_ems_8.6.0_linux_x86_64.zip TIB_ems_8.6.0/rpm/* -d /tmp/tibco-ems
yum install -y /tmp/tibco-ems/*.rpm

#=======================================
# INSTALL TIBCO BW 
#=======================================
unzip /install/TIB_bw_6.8.0_linux26gl23_x86_64.zip -d /tmp/tibco-bw
/tmp/tibco-bw/TIBCOUniversalInstaller-lnx-x86-64.bin -silent -V responseFile="/home/tibco/tibco-install-bw.response"

#=======================================
# INSTALL TIBCO TEA 
#=======================================
unzip /install/TIB_tea_2.4.0_linux26gl23_x86_64.zip -d /tmp/tibco-tea
/tmp/tibco-tea/TIBCOUniversalInstaller-lnx-x86-64.bin -silent -V responseFile="/home/tibco/tibco-install-tea.response"

#=======================================
# START TIBCO TEA
#=======================================
cd $TEA_HOME/bin
./tea &> /home/tibco/tibco-tea.log &

#=======================================
# START TIBCO FTL
#=======================================
cd $FTL_HOME/bin
./tibftlserver -n tibco@localhost:8070 &> /home/tibco/tibco-ftl.log &

#wait for ftl server start completed (could be necessary increase on slow systems)
sleep 20

# create bwadmin context in ftl server
./tibftladmin --ftlserver localhost:8070 -ur $BW_HOME/config/bwadmin_ftlrealmserver.json

#=======================================
# CONFIG MYSQL
#=======================================
mysql < /home/tibco/tibco-bwadmindb.sql

#=======================================
# CONFIG TIBCO BW 
#=======================================
cd $BW_HOME/bin

# install bwagent mariadb driver
cp /home/tibco/mariadb*.jar $BW_HOME/config/drivers/shells/jdbc.mariadb.runtime/runtime/plugins/com.tibco.bw.jdbc.datasourcefactory.mariadb/lib
./bwinstall mariadb-driver

# install bwagent ftl & ems driver
echo "$FTL_HOME/components/shared/1.0.0/plugins" | ./bwinstall ftl-driver
echo "$EMS_HOME/components/shared/1.0.0/plugins" | ./bwinstall ems-driver

# replace bwagent parameters
echo "yes" | cp /home/tibco/tibco-bwagent.ini $BW_HOME/config/bwagent.ini

#=======================================
# REGISTER TIBCO BW to TEA
#=======================================

# switch bwadmin in enterprise mode
./bwadmin mode enterprise

# start bwagent
./bwagent &> /home/tibco/tibco-bwagent.log &

# wait for bwagent start completed (could be necessary increase on slow systems)
sleep 30

# register bwagent to tea server
./bwadmin registerteaagent http://localhost:8777

#=======================================
# FINAL SETUP & CLEAN
#=======================================

# remove install folders
rm -rf /tmp/tibco*

# stop processes
/home/tibco/tibco-stop.sh
