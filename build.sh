#!/usr/bin/env bash

# Variables for image name and tags
IMAGE_NAME="radstudio/interbase"
TAG_LATEST="latest"
TAG_VERSION="2020"
TAG_NUMERIC="2020.6"

# Build the Docker image with the first tag
docker build . \
    --platform linux/amd64 \
    --pull \
    -t ${IMAGE_NAME}:${TAG_LATEST}

# Tag the build image wutg additional version tags
docker tag "${IMAGE_NAME}:${TAG_LATEST}" "${IMAGE_NAME}:${TAG_VERSION}"
docker tag "${IMAGE_NAME}:${TAG_LATEST}" "${IMAGE_NAME}:${TAG_NUMERIC}"

# Echo a success message
echo "Docker image ${IMAGE_NAME} tagged with ${TAG_LATEST}, ${TAG_VERSION}, and ${TAG_NUMERIC}"