#!/bin/bash
# Now the if clause checks the syntax of $PUBLIC_IP . If $PUBLIC_IP is is 0.0.0.0, dynamic check the Public IP or elif fixed PUBLIC_IP in docker-compose.yml, else exit 1.
if [[ "${PUBLIC_IP}" =~ 0.0.0.0 ]] ; then
        # Added a curl to get own public IP for dynamic IPv4 Line 4
        curl https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1?addr=$(curl -s https://api.ipify.org) -qq | grep Space -q
        exit 0
        # Here added Regex check for a correct IPv4
elif [[ "${PUBLIC_IP}" =~ ^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})){3}$ ]] ; then
        curl https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1?addr=${PUBLIC_IP} -qq | grep Space -q
        exit 0
else
        exit 1
fi
