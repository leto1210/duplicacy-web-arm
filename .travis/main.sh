#!/bin/bash

# Performs any provisioning needed for a clean build.
#
# This script is meant to be used either directly
# as a `before_install` step such that the next step
# in the Travis build have the environment properly
# setup.
#
# The script is also handy for debugging - SSH into
# the machine and then call `./.travis/main.sh` to
# have all dependencies set.

set -o errexit

main() {
  setup_dependencies

  echo "INFO:
  Done! Finished setting up Travis-CI machine.
  "
}

# Takes care of updating any dependencies that the
# machine needs.
setup_dependencies() {
  echo "INFO:
  Setting up dependencies.
  "
  #sudo mkdir -p /etc/apt/keyrings
  #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  #cp ./.travis/default.json /tmp/default.json
  #echo \
  #"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  #$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update -y
  sudo apt upgrade docker-ce -y
  #sudo apt install -y docker-ce=20.10.9~3-0~ubuntu-focal

  docker info
}

main
