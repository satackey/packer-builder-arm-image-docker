# Build source codes
FROM golang:1 AS build-env
WORKDIR /src

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Build
COPY main.go ./
COPY vendor vendor
COPY pkg pkg
RUN ls
RUN go build


# Download packer
FROM ubuntu:18.04 AS packer-dl
RUN apt-get -y update && apt-get -y install \
    wget \
    unzip

WORKDIR /download
RUN wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip -q -O packer.zip
RUN unzip -u packer.zip


# Runtime
FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y install \
    binfmt-support \
    kpartx \
    qemu-user-static \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=packer-dl /download/packer /usr/local/bin
COPY --from=build-env /src/packer-builder-arm-image /usr/local/bin
# To start binfmt
COPY docker-entrypoint.sh /root/entrypoint.sh

ENV PACKER_CACHE_DIR /root/packer_cache

WORKDIR /img
VOLUME [ "/img", ${PACKER_CACHE_DIR} ]

ENTRYPOINT [ "/root/entrypoint.sh" ]