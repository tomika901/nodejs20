# Használjuk Ubuntu 22.04 alapú képet
FROM ubuntu:22.04

LABEL author="Matthew Penner" maintainer="matthew@pterodactyl.io"
LABEL org.opencontainers.image.source="https://github.com/pterodactyl/yolks"
LABEL org.opencontainers.image.licenses=MIT

# Frissítjük a csomaglistát és telepítjük a szükséges csomagokat, beállítjuk a nem interaktív módot
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    openssl \
    sqlite3 \
    tzdata \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Beállítjuk a megfelelő időzónát (Európa/Budapest)
RUN ln -fs /usr/share/zoneinfo/Europe/Budapest /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Telepítjük a Node.js-t
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    npm install -g npm

# Hozzáadunk egy felhasználót
RUN useradd -m -d /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Telepítjük a Discord.js-t
RUN npm install discord.js

COPY ./../entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]

