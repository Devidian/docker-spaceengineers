FROM debian:buster-20201117

WORKDIR /root

ADD https://dl.winehq.org/wine-builds/winehq.key \
    https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key \
    https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    /tmp/

COPY winetricks.sh entrypoint.sh /root/

ENV DEBIAN_FRONTEND=noninteractive
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
    apt-get update -qq && \
    apt-get install -qq --no-install-recommends -y \
      software-properties-common \
      wget \
      gnupg && \
    apt-add-repository non-free && \
    apt-key add /tmp/winehq.key && \
    apt-key add /tmp/Release.key && \
    apt-add-repository "deb https://dl.winehq.org/wine-builds/debian/ buster main" && \
    apt-add-repository "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" && \
    apt-get update -qq && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    # && \
    # echo postfix postfix/mailname string 'your.hostname.com' | debconf-set-selections && \
    # echo postfix postfix/main_mailer_type string 'Internet Site'| debconf-set-selections
    apt-get install -qq -y \
      libfaudio0:i386 \
      libfaudio0 && \
    apt-get install -qq -y --install-recommends \
      winehq-staging \
      steamcmd \
      xvfb \
      cabextract && \
    mv /root/winetricks /usr/local/bin/ && \
    chmod +x /usr/local/bin/winetricks && \
    env WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui && \
    bash winetricks.sh && \
    apt-get -qq clean autoclean && \
    apt-get autoremove -qq -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    apt-get install -qq -y --allow-downgrades --install-recommends \
      wine-staging-i386=5.9~buster \
      wine-staging-amd64=5.9~buster \
      wine-staging=5.9~buster \
      winehq-staging=5.9~buster && \
    /root/winetricks --force -q dotnet48

ENTRYPOINT /root/entrypoint.sh
