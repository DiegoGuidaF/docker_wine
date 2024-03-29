FROM ubuntu:16.04
# Prevents annoying debconf errors during builds
ARG DEBIAN_FRONTEND="noninteractive"
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
# Required for adding repositories
        software-properties-common \
# Required for wine
        winbind \
# Required for winetricks
        cabextract \
        p7zip \
        unzip \
        wget \
        zenity \
# CUSTOM
        make \
# Install wine
    && add-apt-repository ppa:wine/wine-builds \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-staging \
# Download wine cache files
    && mkdir -p /home/wine/.cache/wine \
    && wget https://dl.winehq.org/wine/wine-mono/4.6.4/wine-mono-4.6.4.msi \
        -O /home/wine/.cache/wine/wine-mono-4.6.4.msi \
    && wget https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi \
        -O /home/wine/.cache/wine/wine_gecko-2.47-x86.msi \
    && wget https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi \
        -O /home/wine/.cache/wine/wine_gecko-2.47-x86_64.msi \
# Download winetricks and cache files
    && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
        -O /usr/bin/winetricks \
    && chmod +rx /usr/bin/winetricks \
    && mkdir -p /home/wine/.cache/winetricks/win7sp1 \
    && wget https://download.microsoft.com/download/0/A/F/0AFB5316-3062-494A-AB78-7FB0D4461357/windows6.1-KB976932-X86.exe \
        -O /home/wine/.cache/winetricks/win7sp1/windows6.1-KB976932-X86.exe \
# Create user and take ownership of files
    && groupadd -g 1010 wine \
    && useradd -s /bin/bash -u 1010 -g 1010 wine \
    && chown -R wine:wine /home/wine \
# Clean up
    && apt-get autoremove -y \
        software-properties-common \
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove
VOLUME /home/wine
COPY entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
