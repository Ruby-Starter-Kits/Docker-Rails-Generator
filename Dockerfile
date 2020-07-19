FROM ruby:2.7.1-alpine AS builder

LABEL maintainer="Mike Rogers <me@mikerogers.io>"

RUN apk add --no-cache \
    build-base rsync \
    git

FROM builder as rails-installer

# Setup directories within our container to run the code.
RUN mkdir -p /usr/src/bin
RUN mkdir -p /usr/src/App-Template
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install required gems
RUN gem install rails

# Copy the interactive install script
COPY docker/interactive-install.rb /usr/src/bin

# Copy the "better defaults" app template
COPY App-Template /usr/src/App-Template/

# Let's run the rails new command
CMD ["ruby", "/usr/src/bin/interactive-install.rb"]
