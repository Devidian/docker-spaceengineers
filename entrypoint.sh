#!/bin/bash
# VARIABLES
GAME_DIR="/appdata/space-engineers/SpaceEngineersDedicated"
CONFIG_PATH="/appdata/space-engineers/instances/${INSTANCE_NAME}/SpaceEngineers-Dedicated.cfg"
INSTANCE_IP="0.0.0.0"

echo "-------------------------------START------------------------------"
/usr/games/steamcmd +login anonymous +@sSteamCmdForcePlatformType windows +force_install_dir ${GAME_DIR} +app_update 298740 +quit

## CONFIG UPDATES ##
# update IP to 0.0.0.0
CURRENT_IP=$(grep -oEi '<IP>(.*)</IP>' ${CONFIG_PATH} | sed "s=<IP>==g" | sed "s=</IP>==g")
sed -i "s=<IP>.*</IP>=<IP>${INSTANCE_IP}</IP>=g" ${CONFIG_PATH}

# update world save path
CURRENT_WORLDNAME=$(grep -oEi '<WorldName>(.*)</WorldName>' ${CONFIG_PATH} | sed "s=<WorldName>==g" | sed "s=</WorldName>==g")
SAVE_PATH="Z:\\\\appdata\\\\space-engineers\\\\instances\\\\${INSTANCE_NAME}\\\\Saves\\\\${CURRENT_WORLDNAME}";
sed -i "s=<LoadWorld>.*</LoadWorld>=<LoadWorld>${SAVE_PATH}</LoadWorld>=g" ${CONFIG_PATH}

## END UPDATES ##

cd ${GAME_DIR}/DedicatedServer64/
wine SpaceEngineersDedicated.exe -noconsole -ignorelastsession -path Z:\\appdata\\space-engineers\\instances\\${INSTANCE_NAME}
echo "--------------------------------END-------------------------------"
sleep 10