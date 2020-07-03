#!/bin/bash
set -u

docker build $(pwd) -t mikerogers0/rails-installer:latest
