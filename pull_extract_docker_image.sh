#!/bin/bash

FRIGATE_DOCKER_IMAGE="ghcr.io/blakeblackshear/frigate:0.16.3"

apt_install_podman() {
  sudo apt -qq list podman | grep -v "installed" | awk -F/ '{print $1}' | tee "${HOME}/barefrigate/list.txt"
  packages=$(cat ${HOME}/barefrigate/list.txt)

  grep -q '[^[:space:]]' < "/$HOME/barefrigate/list.txt"
  CHECK_LIST=$?

  if [[ $CHECK_LIST -eq 1 ]]; then
    echo "podman is already installed"
  else
    echo "Installing packages"
    sudo apt  -y -qq install podman
  fi
  rm ${HOME}/barefrigate/list.txt
}

pull_and_extract_docker_image() {
  sudo podman pull ${FRIGATE_DOCKER_IMAGE} 
  CONT_ID=$(sudo podman create ${FRIGATE_DOCKER_IMAGE}| head -c 12)
  sudo podman export ${CONT_ID} -o frigate.tar
  sudo podman rm ${CONT_ID}
  sudo podman rmi ${FRIGATE_DOCKER_IMAGE}
  sudo gzip frigate.tar
}

apt_install_podman

mkdir -p "${HOME}/barefrigate/frigate"

cd "${HOME}/barefrigate/frigate"
rm -rf *

cd "${HOME}/barefrigate"

pull_and_extract_docker_image

cd "${HOME}/barefrigate/frigate"

sudo tar zxvf ../frigate.tar.gz

cd "${HOME}/barefrigate"

sudo rm frigate.tar.gz

