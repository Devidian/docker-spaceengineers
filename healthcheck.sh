#!/bin/bash

if [ -z "${PUBLIC_IP}" ]; then
  PUBLIC_IP="$(curl -s https://ifconfig.me/ip)"
fi

if curl https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1?addr=${PUBLIC_IP} -qq | grep Space -q
then
        exit 0
else
        exit 1
fi
