#!/bin/bash

TAG_1="$ARIA_M"-"$ALPINE_M""$ALPINE_P"
TAG_2="${TRAVIS_TAG:-latest}"

if [ "$TRAVIS_PULL_REQUEST" = "true" ] || [ "$TRAVIS_BRANCH" != "master" ]; then
  docker buildx build \
     --build-arg ALPINE_M \
     --build-arg ALPINE_P \
     --build-arg ARIA_M \
     --build-arg ARIA_P \
    --progress plain \
    --platform=linux/arm64,linux/arm/v7,linux/arm/v6,linux/amd64,linux/386 \
    .
  exit $?
fi
echo $DOCKER_PASSWORD | docker login -u dockerpirate --password-stdin &> /dev/null

docker buildx build \
     --build-arg ALPINE_M \
     --build-arg ALPINE_P \
     --build-arg ARIA_M \
     --build-arg ARIA_P \
     --progress plain \
    --platform=linux/arm64,linux/arm/v7,linux/arm/v6,linux/amd64,linux/386 \
    -t $DOCKER_REPO:$TAG_1 \
    --push .

docker buildx build \
     --build-arg ALPINE_M \
     --build-arg ALPINE_P \
     --build-arg ARIA_M \
     --build-arg ARIA_P \
     --progress plain \
    --platform=linux/arm64,linux/arm/v7,linux/arm/v6,linux/amd64,linux/386 \
    -t $DOCKER_REPO:$TAG_2 \
    --push .
