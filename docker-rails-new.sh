#!/bin/bash
set -u

# This will setup a new Rails Project which will run under docker.
# The aim is to only require developers install docker to try Rails.
# 
# To run, in terminal run:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/MikeRogers0/Docker-Rails-New/master/docker-rails-new.sh)"

echo "🚂☁☁ Running Rails Docker Install ☁☁☁"

## TODO: Check docker exists

## Run the docker image which runs the setup
echo "🚂☁☁ Running 'rails new' with sensible defaults for docker"
docker run --rm -it -v $(pwd):/usr/src/app mikerogers0/docker-rails-new:latest

## TODO: Now setup the App under docker (bin/setup)

## TODO: Turn on the app & open it in the browser.
