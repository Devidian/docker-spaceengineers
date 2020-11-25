FROM debian:buster-20201117

WORKDIR /root

COPY winetricks.sh entrypoint.sh /root/

ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/root/server
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# Add i386 architecture support
# Add non-free repo for steamcmd
# Install wine
# Steam config setup
# Wine Setup
# downgrade wine to install dotnet48
RUN dpkg --add-architecture i386 && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq software-properties-common wget gnupg && \
    apt-add-repository non-free && \
    wget -P /tmp \
      https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add /tmp/winehq.key && \
    rm -f /tmp/winehq.key && \
    wget -P /tmp \
      https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key && \
    apt-key add /tmp/Release.key && \
    rm -f /tmp/Release.key && \
    apt-add-repository "deb https://dl.winehq.org/wine-builds/debian/ buster main" && \
    apt-add-repository "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      libfaudio0:i386 \
      libfaudio0 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --install-recommends \
      winehq-staging \
      steamcmd \
      xvfb \
      cabextract && \
    wget -P /usr/local/bin \
       https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/local/bin/winetricks && \
    env WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui && \
    /root/winetricks.sh && \
    rm -f /root/winetricks.sh && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --allow-downgrades --install-recommends \
      wine-staging-i386=5.9~buster \
      wine-staging-amd64=5.9~buster \
      wine-staging=5.9~buster \
      winehq-staging=5.9~buster && \
    /usr/local/bin/winetricks --force -q dotnet48 && \
    DEBIAN_FRONTEND=noninteractive apt-get remove -qq -y \
      gnupg \
      wget \
      software-properties-common && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -qq -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT /root/entrypoint.sh
