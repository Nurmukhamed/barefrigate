#!/bin/bash

PWD="$(pwd)"

mkdir -p "${PWD}/frigate"

sudo docker pull ghcr.io/blakeblackshear/frigate:0.16.3

CONT_ID=$(sudo docker create ghcr.io/blakeblackshear/frigate:0.16.3)

sudo docker export ${CONT_ID} -o frigate/frigate.tar

sudo gzip frigate/frigate.tar

cd "${PWD}/frigate"

sudo tar zxvf frigate.tar.gz

cd "${PWD}"
