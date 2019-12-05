FROM ubuntu:bionic

# Metadata
LABEL maintainer="Mimix"
LABEL version="0.0.7"

# Packages
RUN apt-get update -y
RUN apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1

# Install app
RUN mkdir -p /app/mvp
ADD ./out/mvp-linux-x64 /app/mvp

# Run app
CMD [ "/app/mvp/mvp", "--no-sandbox" ]

# file /app/mvp/mvp