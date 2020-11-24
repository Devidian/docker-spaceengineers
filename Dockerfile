FROM debian:buster-20201117

ADD https://dl.winehq.org/wine-builds/winehq.key \
    https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key \
    https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    /tmp/

COPY winetricks.sh entrypoint.sh /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/root/server

# Add i386 architecture support
#Add non-free repo for steamcmd

RUN dpkg --add-architecture i386 && \
    apt update -qq && \
    apt install -qq --no-install-recommends -y \
      software-properties-common \
      wget \
      gnupg && \
    apt-add-repository non-free && \
    apt-key add /tmp/winehq.key && \
    apt-key add Release.key && \
    apt-add-repository "deb https://dl.winehq.org/wine-builds/debian/ buster main" && \
    apt-add-repository "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" && \
    apt update -qq && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    # && \
    # echo postfix postfix/mailname string 'your.hostname.com' | debconf-set-selections && \
    # echo postfix postfix/main_mailer_type string 'Internet Site'| debconf-set-selections
    apt install -qq --yes \
      libfaudio0:i386 \
      libfaudio0 && \
    apt install -qq --yes --install-recommends \
      winehq-staging \
      steamcmd \
      xvfb \
      cabextract && \
    mv /tmp/winetricks /usr/local/bin/ && \
    chmod +x /usr/local/bin/winetricks && \
    env WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui && \
    bash winetricks.sh && \
    apt-get -qq clean autoclean && \
    apt-get autoremove -qq -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    apt install -qq --yes --allow-downgrades --install-recommends \
      wine-staging-i386=5.9~buster \
      wine-staging-amd64=5.9~buster \
      wine-staging=5.9~buster \
      winehq-staging=5.9~buster && \
    /root/winetricks --force -q dotnet48

ENTRYPOINT /root/entrypoint.sh
