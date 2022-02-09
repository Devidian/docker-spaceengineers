#!/bin/bash

# As docker can only run one process we have to use this script to get Xvfb running while calling winetricks stuff
Xvfb :5 -screen 0 1024x768x16 &
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/root/server WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/root/server winetricks corefonts 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/root/server winetricks sound=disabled 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/root/server DISPLAY=:5.0 winetricks -q vcrun2019 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/root/server DISPLAY=:5.0 winetricks -q --force dotnet48