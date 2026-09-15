#!/bin/bash
# Healthcheck for the Space Engineers dedicated server.
#
# The previous implementation queried Steam's public API with PUBLIC_IP:
#     curl "https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1?addr=${PUBLIC_IP}"
# That only returns the server when PUBLIC_IP is the server's real, public,
# Steam-registered address. Behind NAT, or when PUBLIC_IP is a private/LAN
# address, the lookup can never match and the container is permanently reported
# unhealthy.
#
# Report healthy instead when the server process is up and its game port
# (27016/udp = 0x6988 by default) is bound.
set -e

pgrep -f 'SpaceEngineersDedicated\.exe' >/dev/null 2>&1 || exit 1
grep -q ':6988 ' /proc/net/udp 2>/dev/null || exit 1
exit 0
