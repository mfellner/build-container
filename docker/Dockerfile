FROM alpine:3.2

# Here we use several hacks collected from https://github.com/gliderlabs/docker-alpine/issues/11:
# 1. install GLibc (which is not the cleanest solution at all)
# 2. hotfix /etc/nsswitch.conf, which is apperently required by glibc and is not used in Alpine Linux
# 3. Finally, install JRE 8

RUN apk add --update bash wget ca-certificates && \
    wget -nv \
      "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
      "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    wget -nv "http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh" && \
    bash ./Miniconda-latest-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm ./Miniconda-latest-Linux-x86_64.sh && \
    wget -nv \
      --no-check-certificate \
      --no-cookies \
      --header "Cookie: oraclelicense=accept-securebackup-cookie" \
      -O java.tar.gz \
      http://download.oracle.com/otn-pub/java/jdk/8u45-b14/server-jre-8u45-linux-x64.tar.gz && \
      tar -xzf java.tar.gz && \
      rm java.tar.gz && \
      ln -s /jdk1.8.0_45/bin/* /usr/local/bin/ && \
    apk del bash wget ca-certificates && \
    rm /var/cache/apk/*

# This directory must be the same in both the build- and runtime container.
WORKDIR /docker

# When building the runtime-container image inside the build-container,
# we could simply add the application artifact directly. But then the
# command would fail when using Docker Compose since there would be
# nothing to copy. The .dockerignore file keeps unwantend content out.
COPY . ./

# We defined a unique name for the application artifact in the Leiningen
# project file so we can simply find it, no matter which subdirectory.
CMD java -jar $(find -name "app.uber.jar")
