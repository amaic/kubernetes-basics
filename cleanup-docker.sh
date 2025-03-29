#!/bin/bash

[[ -n $(which docker) ]] && docker system prune --all --volumes --force

# https://docs.docker.com/engine/install/ubuntu/#uninstall-old-versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; 
do sudo apt-get remove $pkg; 
done

sudo apt-get remove -y docker-ce docker-ce-cli docker-ce-rootless-extras docker-buildx-plugin docker-compose-plugin
