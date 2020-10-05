#!/bin/bash

# As docker can only run one process we have to use this script to get Xvfb running while calling winetricks stuff
env DISPLAY=:5.0
Xvfb :5 -screen 0 1024x768x16 & 
winetricks -q corefonts 
winetricks vcrun2013 
winetricks vcrun2017 
winetricks dotnet472 
winetricks sound=disabled
