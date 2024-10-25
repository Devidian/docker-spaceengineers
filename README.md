# Space Engineers Dedicated Debian Docker Container

First of all thanks to [7thCore](https://github.com/7thCore) and [mmmaxwwwell](https://github.com/mmmaxwwwell) for their great prework making a linux dedicated server for Space Engineers real!

I took parts of their projects to create this one (see credits)

## Why?

I wanted to have a more cleaner docker container with less dependencies (integrate sesrv-script parts instead of wget the whole script) and a little more configuration through composer files.

## KeyFacts

| Key         | :latest              | :winestaging         |
| ----------- | -------------------- | -------------------- |
| OS          | Debian 12 (Bookworm) | Debian 12 (Bookworm) |
| Wine        | 9.0.0.0~bookworm-1   | 9.20~bookworm-1      |
| Docker size | ~1.73GB compressed   | ~1.77GB compressed   |
| Build Time  | ~ 7-8 Minutes        | ~ 19 Minutes         |

## How to use

First you have to use the `Space Engineers Dedicated Server` Tool to setup your world.

(detailed instructions follow when requested)

After you have saved your world upload it (the instance directory) to your docker host machine `/appdata/space-engineers/instances/`.

## Using docker-compose with precompiled docker image (devidian/spaceengineers)

Create a [docker-compose.yml](docker-compose.yml) (see example below) and execute `docker-compose up -d`

Do not forget to rename `TestInstance` with your instance name!

### example composer - just copy and adjust

```yaml
services:
  se-server:
    image: devidian/spaceengineers:winestaging
    container_name: se-ds-docker
    restart: unless-stopped
    volumes:
      # left side: your docker-host machine
      # right side: the paths in the image (!!do not change!!)
      - /appdata/space-engineers/plugins:/appdata/space-engineers/plugins
      - /appdata/space-engineers/instances:/appdata/space-engineers/instances
      - /appdata/space-engineers/SpaceEngineersDedicated:/appdata/space-engineers/SpaceEngineersDedicated
      - /appdata/space-engineers/steamcmd:/root/.steam
    ports:
      - target: 27016
        published: 27016
        protocol: udp
        mode: host
    environment:
      - WINEDEBUG=-all
      - INSTANCE_NAME=TestInstance
      - PUBLIC_IP=1.2.3.4
      # public ip required for healthcheck
```

## Build the image yourself from source

Download this repository and run `docker-compose up -d`

## Use the docker image as source for your own image

If you want to extend the image create a `Dockerfile` and use `FROM devidian/spaceengineers:latest`

## FAQ

### Can i use plugins?

Yes just copy plugins to `/appdata/space-engineers/plugins` and they will be added or removed by the [entrypoint.sh](entrypoint.sh) script

### Can i run mods?

Yes as they are saved in your world, the server will download them on the first start.

### Can i contribute?

Sure, feel free to submit merge requests or issues if you have anything to improve this project. If you just have a question, use Github Discussions.

## Credits

| User                                                      | repo / fork                                                            | what (s)he did for this project |
| --------------------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------- |
| [mmmaxwwwell](https://github.com/mmmaxwwwell)             | https://github.com/mmmaxwwwell/space-engineers-dedicated-docker-linux  | downgrading for dotnet48        |
| [7thCore](https://github.com/7thCore)                     | https://github.com/7thCore/sesrv-script                                | installer bash script           |
| [Diego Lucas Jimenez](https://github.com/tanisdlj)        | -                                                                      | Improved Dockerfile             |
| [EthicalObligation](https://github.com/EthicalObligation) | https://github.com/EthicalObligation/docker-spaceengineers-healthcheck | Healthcheck & Quicker startup   |
| [draconb](https://github.com/draconb)                     | -                                                                      | Hints for plugin support        |

## Known issues

- **VRage Remote Client**
  - I personally could not manage to connect with te remote client, if anyone gets a connection please tell me (and maybe how you fixed it)
