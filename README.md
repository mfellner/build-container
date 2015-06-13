# Build-container

This project demonstrates how to create a minimal runtime-container with Docker
by utilizing a build-container.

* ./Dockerfile contains the configuration for the build-container.
* ./docker/Dockerfile contains the configuration for the runtime-container.

**The container images can be built and run in two ways:**

    ./build.sh
    docker run -p 8080:8080 mfellner/hello-clojure

This way, the build-container installs the necessary build-chain and then
uses docker to build the runtime-container image. This is possible by mapping
the docker.sock of the host into the container using `-v /var/run/docker.sock:/var/run/docker.sock`.

It would also be possible to map the docker-client binary this way.

**Or with Docker Compose:**

    docker-compose up

When using this method, the runtime-container image is actually built by Docker Compose
but the volume of the build-container, containing the application artifact, is mapped
into the runtime container.

#### Notes

* In order to support both the manual build and Docker Compose, the two Dockerfiles
need to be located in separate directories. Furthermore, the directory "docker/", which
contains the configuration for the runtime-container, needs to be used as a `WORKDIR`
in both containers and must be used as a `VOLUME` on the build-container.
* Automated builds on Docker Hub are not supported (but you could use a CI service instead).

## License

Copyright © 2015 Maximilian Fellner
