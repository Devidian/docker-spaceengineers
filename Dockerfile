# ============== build stage ==================
FROM debian as builder

WORKDIR /root

# Add i386 architecture support
RUN dpkg --add-architecture i386
# Install software properties common
# Install wget
RUN apt update && \
    apt install --yes software-properties-common wget gnupg
#Add non-free repo for steamcmd
RUN apt-add-repository non-free

# Wine ands stuff
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key
RUN wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key && \
    apt-key add Release.key

RUN apt-add-repository "deb https://dl.winehq.org/wine-builds/debian/ buster main" && \
    apt-add-repository "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" && \
    apt update

# Steam config setup
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections 
    # && \
    # echo postfix postfix/mailname string 'your.hostname.com' | debconf-set-selections && \
    # echo postfix postfix/main_mailer_type string 'Internet Site'| debconf-set-selections


# Install packages
RUN apt install --yes \
    libfaudio0:i386 \
    libfaudio0 && \
    apt install --yes --install-recommends \
    winehq-staging \
    steamcmd

RUN apt install --yes xvfb cabextract

# Install winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    mv winetricks /usr/local/bin/ && \
    chmod +x /usr/local/bin/winetricks

# Wine Setup
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/root/server

RUN env WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui

COPY winetricks.sh .

RUN bash winetricks.sh

RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/

# downgrade wine to install dotnet48
RUN apt install --yes --allow-downgrades --install-recommends \
    wine-staging-i386=5.9~buster \
    wine-staging-amd64=5.9~buster \
    wine-staging=5.9~buster \
    winehq-staging=5.9~buster

RUN winetricks --force -q dotnet48

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT /root/entrypoint.sh