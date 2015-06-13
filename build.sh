#!/usr/bin/env bash

get_var_or_default() {
  local test=${!1}
  if [ -z "$test" ]; then
    echo $2
  else
    echo $test
  fi
}

TARGET_USER="mfellner"
TARGET_NAME="hello-clojure"
TARGET_VERSION=$1
BUILD_IMAGE="${TARGET_NAME}-build"

docker build -t $BUILD_IMAGE .

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e TARGET_USER="mfellner" \
  -e TARGET_NAME="hello-clojure" \
  -e TARGET_VERSION=$(get_var_or_default "TARGET_VERSION" "latest") \
  $BUILD_IMAGE
