# The devcontainer.json file defines a build so the Dockerfile is used to build a new image.
# The base image is from Microsoft at https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/javascript-node/tags.
# The name "bookworm" refers to the Debian Bookworm release, which is the base OS for this image, adding the name
# fixes the Linux release used.

FROM mcr.microsoft.com/devcontainers/base:ubuntu
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# Install system dependencies required for building and unpacking Ada tooling
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    unzip \
    ca-certificates \
    && JDK=$(apt-cache search --names-only '^openjdk-[0-9]+-jdk$' \
        | awk '{print $1}' \
        | sort -t- -k2 -n \
        | tail -n1) \
    && echo "Installing $JDK" \
    && apt-get install -y --no-install-recommends "$JDK" maven \
    && rm -rf /var/lib/apt/lists/*

RUN GRADLE_VERSION=$(curl -fsSL https://services.gradle.org/versions/current | jq -r .version) \
    && curl -fsSL -o /tmp/gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    && unzip -q /tmp/gradle.zip -d /opt \
    && ln -s "/opt/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle \
    && rm /tmp/gradle.zip