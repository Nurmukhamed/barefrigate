#!/bin/bash


apt_remove_podman() {
  sudo apt -qq list podman | grep -v "installed" | awk -F/ '{print $1}' | tee "${HOME}/barefrigate/list.txt"
  packages=$(cat ${HOME}/barefrigate/list.txt)

  grep -q '[^[:space:]]' < "/$HOME/barefrigate/list.txt"
  CHECK_LIST=$?

  if [[ $CHECK_LIST -eq 1 ]]; then
    echo "podman is already installed"
    sudo apt -y -qq purge podman
  else
    echo "podman is not installed."
  fi
  rm ${HOME}/barefrigate/list.txt
}

apt_remove_podman

sudo rm -rf "$HOME/barefrigate"

