# Space Engineers Dedicated Debian Docker Container

First of all thanks to [7thCore](https://github.com/7thCore) and [mmmaxwwwell](https://github.com/mmmaxwwwell) for their great prework making a linux dedicated server for Space Engineers real!

I took parts of these projects to create this one:

https://github.com/7thCore/sesrv-script => installing prerequisites

https://github.com/mmmaxwwwell/space-engineers-dedicated-docker-linux => downgrading for dotnet48

# Why?

I wanted to have a more cleaner docker container with less dependencies (integrate sesrv-script parts instead of wget the whole script) and a little more configuration through composer files.

# How to use

First you have to use the `Space Engineers Dedicated Server` Tool to setup your world.

(detailed instructions follow when requested)

After you have saved your world upload it (the instance directory) to your docker host machine `/appdata/space-engineers/instances/`.


## Using docker-compose with premade docker image
Create a `docker-compose.yml` (see example below) and execute `docker-compose up -d`

### example composer file (just copy and adjust)
```yaml
version: '3.8'

services:
  se-server:
    image: devidian/spaceengineers
    container_name: se-ds-docker
    restart: unless-stopped
    volumes:
      - /appdata/space-engineers/instances:/appdata/space-engineers/instances
      - /appdata/space-engineers/SpaceEngineersDedicated:/appdata/space-engineers/SpaceEngineersDedicated
      - /appdata/space-engineers/steamcmd:/root/.steam
    ports:
      - target: 8080
        published: 18080
        protocol: tcp
        mode: host
      - target: 27016
        published: 27016
        protocol: udp
        mode: host
    environment: 
      - WINEDEBUG=-all 
      # - WINEDEBUG=+all 
      # - WINEDEBUG=warn+heap
      - GAME_DIR=/appdata/space-engineers/SpaceEngineersDedicated
      - GAME_SAVE=Z:\\appdata\\space-engineers\\instances\\TestInstance
```

# Build the image yourself from source
Download this repository and run `docker-compose up -d`

# Use the docker image as source for your own image
If you want to extend the image create a `Dockerfile` and use `FROM devidian/spaceengineers`

# FAQ
## Can i run mods?
Yes as they are saved in your world, the server will download them on the first start.