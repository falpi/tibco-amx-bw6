#!/bin/bash
   
# prepare environment
. /home/tibco/tibco-profile.sh

# if tibco products are not installed execute setup
if [[ ! -d /opt/tibco ]]
then
   echo Starting TIBCO products setup...
   /home/tibco/tibco-install.sh &> /home/tibco/tibco-install.log
fi

# start tibco tea
echo Starting TIBCO TEA Server...
cd $TEA_HOME/bin
./tea &> /home/tibco/tibco-tea.log &

# start tibco ftl server
echo Starting TIBCO FTL Server...
cd $FTL_HOME/bin
./tibftlserver -n test@localhost:8070 &> /home/tibco/tibco-ftl.log &

# wait for tibco ftl server start  (could be necessary increase on slow systems)
sleep 20

# re-create bwadmin context in ftl server to avoid problems
echo Configuring TIBCO FTL Server...
./tibftladmin --ftlserver localhost:8070 -ur $BW_HOME/config/bwadmin_ftlrealmserver.json
  
# start bwagent
echo Starting TIBCO BW Agent...
cd $BW_HOME/bin
./bwagent &> /home/tibco/tibco-bwagent.log &


