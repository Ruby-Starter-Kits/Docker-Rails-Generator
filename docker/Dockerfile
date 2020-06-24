FROM ruby:2.7.1-buster AS development

LABEL maintainer="Mike Rogers <me@mikerogers.io>"

# Setup directories within our container to run the code.
RUN mkdir -p /usr/src/bin
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install required gems
RUN gem install rails

COPY interactive-install.rb /usr/src/bin

# Let's run the rails new command
CMD ["ruby", "/usr/src/bin/interactive-install.rb"]
