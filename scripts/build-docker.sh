#!/bin/bash
set -u

docker build $(pwd) -t rubystarterkits/rails-installer:latest
