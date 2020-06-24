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
echo "🚂☁☁ Running 'rails new' with sensible defaults for docker ☁☁☁"
docker run --rm -it -v $(pwd):/usr/src/app mikerogers0/docker-rails-new:latest

## Now setup the App under docker
echo "🚂☁☁ Building docker container for your app ☁☁☁"
docker-compose --file $(pwd)/App/docker-compose.yml build

echo "🚂☁☁ Completing installation of Rails ☁☁☁"
docker-compose --file $(pwd)/App/docker-compose.yml run --rm web /bin/sh -c 'bundle && rails webpacker:install && bin/setup'

## Summarise what people need to do:
echo "🚂☁☁ You're good to go ☁☁☁"
echo "Installed to directory: $(pwd)/App"
echo "To start your rails server: cd $(pwd)/App && docker-compose up"
echo "Then navigate to: http://127.0.0.1:3000"
