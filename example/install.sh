#!/bin/bash

# 1. Copy Instance to /appdata/space-engineers/instances/
mkdir -p /appdata/space-engineers/instances/
cp -r DockerQuickStart /appdata/space-engineers/instances/
# 2. start composer file
docker-compose up -d

# 3. Enjoy!