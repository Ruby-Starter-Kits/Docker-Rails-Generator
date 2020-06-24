#!/bin/bash
set -u

docker build $(pwd)/docker -t mikerogers0/docker-rails-new:latest
