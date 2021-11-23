# Space Engineers Dedicated Debian Docker Container

First of all thanks to [7thCore](https://github.com/7thCore) and [mmmaxwwwell](https://github.com/mmmaxwwwell) for their great prework making a linux dedicated server for Space Engineers real!

I took parts of their projects to create this one (see credits)

# Why?

I wanted to have a more cleaner docker container with less dependencies (integrate sesrv-script parts instead of wget the whole script) and a little more configuration through composer files.

# KeyFacts

| Key         | Value                |
| ----------- | -------------------- |
| OS          | Debian 11 (Bullseye) |
| Wine        | 6 (stable)           |
| Docker size | ~4.6GB uncompressed  |

# How to use

First you have to use the `Space Engineers Dedicated Server` Tool to setup your world.

(detailed instructions follow when requested)

After you have saved your world upload it (the instance directory) to your docker host machine `/appdata/space-engineers/instances/`.

## Using docker-compose with premade docker image

Create a `docker-compose.yml` (see example below) and execute `docker-compose up -d`

Do not forget to rename `TestInstance` with your instance name!

### example composer file (just copy and adjust)

```yaml
version: "3.8"

services:
  se-server:
    image: devidian/spaceengineers
    # if you want to run multiple servers you will have to change container_name and published ports
    container_name: se-ds-docker
    restart: unless-stopped
    volumes:
      # left side: your docker-host machine
      # right side: the paths in the image (!!do not change!!)
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
      # change TestInstance to your instance name
      - INSTANCE_NAME=TestInstance
```

# Build the image yourself from source

Download this repository and run `docker-compose up -d`

# Use the docker image as source for your own image

If you want to extend the image create a `Dockerfile` and use `FROM devidian/spaceengineers:latest`

# FAQ

## Can i run mods?

Yes as they are saved in your world, the server will download them on the first start.

## Can i contribute?

Sure, feel free to submit merge requests or issues if you have anything to improve this project. If you just have a question, use Github Discussions.

# Credits

| User                                               | repo                                                                  | what (s)he did for this project |
| -------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------- |
| [mmmaxwwwell](https://github.com/mmmaxwwwell)      | https://github.com/mmmaxwwwell/space-engineers-dedicated-docker-linux | downgrading for dotnet48        |
| [7thCore](https://github.com/7thCore)              | https://github.com/7thCore/sesrv-script                               | installer bash script           |
| [Diego Lucas Jimenez](https://github.com/tanisdlj) | -                                                                     | Improved Dockerfile             |

# Known issues

- **VRage Remote Client**
  - I personally could not manage to connect with te remote client, if anyone gets a connection please tell me (and maybe how you fixed it)
- **Error: No IP assigned.**
  - This is an issue in the official dedicated server files that can only be fixed by keen [see this issue](https://github.com/KeenSoftwareHouse/SpaceEngineers/issues/611)