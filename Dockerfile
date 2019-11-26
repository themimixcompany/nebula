FROM ubuntu:bionic

# Metadata
LABEL maintainer="Mimix"
LABEL version="0.0.6"

# Runtime
RUN apt-get update -y

# Runtime dependencies
RUN apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1

# Base dir
RUN mkdir -p /app/mvp

# Import executables
ADD ./out/mvp-linux-x64 /app/mvp

# Run app
CMD [ "/app/mvp/mvp", "--no-sandbox" ]
