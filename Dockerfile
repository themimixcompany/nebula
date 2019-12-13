FROM ubuntu:bionic

# Metadata
LABEL maintainer="Mimix"
LABEL version="0.0.7"

# Packages
RUN apt-get update -y
RUN apt-get install -y software-properties-common build-essential curl sudo git
RUN apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm install -g electron
RUN npm install -g electron-forge

# Staging
RUN mkdir -p /var/lib/staging
ADD . /var/lib/staging
RUN (cd /var/lib/staging; npm install; electron-forge package --platform=linux)

# Install app
RUN mkdir -p /app
RUN mv /var/lib/staging/out/nebula-linux-x64 /app/nebula

# Run app
CMD [ "/app/nebula/nebula", "--no-sandbox" ]
