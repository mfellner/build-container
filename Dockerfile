FROM ubuntu:15.04

# Install build tools (the docker-client could also be mapped from the host)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

RUN apt-get update && apt-get -y install \
    wget \
    openjdk-8-jdk \
    docker.io && \
    ln -sf /usr/bin/docker.io /usr/local/bin/docker

RUN wget -nv -P /usr/local/bin \
    https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x /usr/local/bin/lein

ENV LEIN_ROOT true

# Add application sources
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# This directory must be the same in both the build- and runtime container.
WORKDIR /docker

COPY project.clj project.clj

# Cache dependencies.
RUN lein install

COPY src/ src/

# Configure Docker container
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ENV TARGET_USER mfellner
ENV TARGET_NAME hello-clojure
ENV TARGET_VERSION latest

# Build the application artifact.
RUN lein uberjar

# Files for building the runtime-container image.
COPY docker/Dockerfile Dockerfile
COPY docker/.dockerignore .dockerignore

# This volume will be used when running the containers with Docker Compose.
# We must declare it *after* copying/creating all files.
VOLUME /docker

# The docker-client binary is installed in this container and connects
# to the mapped socket on the host. We could also map the docker-client.
CMD docker build -t $TARGET_USER/$TARGET_NAME:$TARGET_VERSION .
