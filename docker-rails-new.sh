#!/bin/bash
set -u

# This will setup a new Rails Project which will run under docker.
# The aim is to only require developers install docker to try Rails.
# 
# To run, in terminal run:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/MikeRogers0/Docker-Rails-New/master/docker-rails-new.sh)"

echo "Docker Rails New - Setup a new rails app under Docker"

## TODO: Check docker exists

## Run the docker image which runs the setup
docker run --rm -it -e HOST_PWD=$(pwd) -v $(pwd):/usr/src/app ruby:2.7.1-buster /bin/sh -c 'cd /usr/src/app && bash'

## TODO: Now setup the App under docker (bin/setup)

## TODO: Turn on the app & open it in the browser.
