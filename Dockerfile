FROM debian:bookworm-20240513-slim

WORKDIR /root

# ARG only available during build
# never env DEBIAN_FRONTEND=noninteractive !!
ARG DEBIAN_FRONTEND=noninteractive
ARG WINEBRANCH=staging
ARG WINEVERSION=9.9~bookworm-1

ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/root/server
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN \
  dpkg --add-architecture i386 && \
  apt-get -qq -y update && \
  apt-get upgrade -y -qq && \
  apt-get install -y -qq software-properties-common curl gnupg2 wget && \
  # add repository keys
  mkdir -pm755 /etc/apt/keyrings && \
  wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
  # add repositories
  echo "deb http://ftp.us.debian.org/debian bookworm main non-free" > /etc/apt/sources.list.d/non-free.list && \
  wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN \
  apt-get update -qq && \
  echo steam steam/question select "I AGREE" | debconf-set-selections && \
  echo steam steam/license note '' | debconf-set-selections && \
  apt-get install -qq -y \
  libfaudio0:i386 \
  libfaudio0 
RUN \ 
  apt-get install -qq -y --install-recommends \
  winehq-${WINEBRANCH}=${WINEVERSION} \
  wine-${WINEBRANCH}-i386=${WINEVERSION} \
  wine-${WINEBRANCH}-amd64=${WINEVERSION} \
  wine-${WINEBRANCH}=${WINEVERSION} \
  steamcmd \
  xvfb \
  cabextract && \
  curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
  chmod +x /usr/local/bin/winetricks 

# Winetricks (This block uses most of the build time)
COPY winetricks.sh /root/
RUN \
  /root/winetricks.sh && \
  rm -f /root/winetricks.sh && \
  # Remove stuff we do not need anymore to reduce docker size
  apt-get remove -qq -y \
  gnupg2 \
  software-properties-common && \
  apt-get autoremove -qq -y && \
  apt-get -qq clean autoclean && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY healthcheck.sh /root/
HEALTHCHECK --interval=60s --timeout=60s --start-period=600s --retries=3 CMD [ "/root/healthcheck.sh" ]

COPY entrypoint.sh /root/
ENTRYPOINT /root/entrypoint.sh