#!/bin/bash
server=$(curl https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1?addr=$INSTANCE_IP -qq)
if echo $server | grep Space -q
then
        exit 0
else
        exit 1
fi