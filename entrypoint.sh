#!/bin/bash
# VARIABLES
GAME_DIR="/appdata/space-engineers/SpaceEngineersDedicated"
CONFIG_PATH="/appdata/space-engineers/instances/${INSTANCE_NAME}/SpaceEngineers-Dedicated.cfg"
if [ -z ${INSTANCE_IP+x} ]; then INSTANCE_IP=$(hostname -I | sed "s= ==g"); fi


echo "-------------------------------INSTALL & UPDATE------------------------------"
/usr/games/steamcmd +force_install_dir ${GAME_DIR} +login anonymous +@sSteamCmdForcePlatformType windows +app_update 298740 +quit

echo "---------------------------------UPDATE CONFIG-------------------------------"
# update IP to host external ip
CURRENT_IP=$(grep -oEi '<IP>(.*)</IP>' ${CONFIG_PATH} | sed "s=<IP>==g" | sed "s=</IP>==g")
sed -i "s=<IP>.*</IP>=<IP>${INSTANCE_IP}</IP>=g" ${CONFIG_PATH}

# update world save path
CURRENT_WORLDNAME=$(grep -oEi '<WorldName>(.*)</WorldName>' ${CONFIG_PATH} | sed "s=<WorldName>==g" | sed "s=</WorldName>==g")
SAVE_PATH="Z:\\\\appdata\\\\space-engineers\\\\instances\\\\${INSTANCE_NAME}\\\\Saves\\\\${CURRENT_WORLDNAME}";
sed -i "s=<LoadWorld>.*</LoadWorld>=<LoadWorld>${SAVE_PATH}</LoadWorld>=g" ${CONFIG_PATH}

echo "-----------------------------CURRENT CONFIGURATION---------------------------"
echo "GAME_DIR=$GAME_DIR"
echo "CONFIG_PATH=$CONFIG_PATH"
echo "INSTANCE_IP=$INSTANCE_IP"
echo "CURRENT_IP=$CURRENT_IP"
echo "CURRENT_WORLDNAME=$CURRENT_WORLDNAME"
echo "SAVE_PATH=$SAVE_PATH"
## END UPDATES ##
wine --version
echo "----------------------------------START GAME---------------------------------"
rm /appdata/space-engineers/instances/${INSTANCE_NAME}/*.log
cd ${GAME_DIR}/DedicatedServer64/
wine SpaceEngineersDedicated.exe -noconsole -ignorelastsession -path Z:\\appdata\\space-engineers\\instances\\${INSTANCE_NAME} > check.log & while ! grep "Error: No IP assigned" check.log >&/dev/null; do sleep 1; done && echo 'Killing' && wineserver -k9 && exit 1
echo "-----------------------------------END GAME----------------------------------"
sleep 1
echo "-----------------------------------BYE !!!!----------------------------------"