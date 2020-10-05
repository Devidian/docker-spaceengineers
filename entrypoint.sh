#!/bin/bash
echo "-------------------------------START------------------------------"
/usr/games/steamcmd +login anonymous +@sSteamCmdForcePlatformType windows +force_install_dir ${GAME_DIR} +app_update 298740 +quit
cd ${GAME_DIR}/DedicatedServer64/
wine ${GAME_DIR}/DedicatedServer64/SpaceEngineersDedicated.exe -noconsole -path ${GAME_SAVE} -ignorelastsession
sleep 5
echo "--------------------------------END-------------------------------"