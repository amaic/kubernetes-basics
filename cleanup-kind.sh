#!/bin/bash

sed --in-place '/kind completion/d' ~/.bashrc

sudo rm /usr/local/bin/kind
