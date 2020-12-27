FROM ruby:2.7.2-alpine AS builder

LABEL maintainer="Mike Rogers <me@mikerogers.io>"

RUN apk --no-cache add --virtual build-dependencies \
      build-base \
      # Install nokogiri
      zlib-dev \
      libxml2-dev \
      libxslt-dev \
      # PG Gem
      postgresql-dev \
      # JavaScript Requirements
      yarn \
      # FFI Bindings in ruby (Run C Commands)
      libffi-dev

RUN apk --no-cache add \
      # ActiveStorage file inspection
      file \
      # Time zone data
      tzdata \
      # JS Libraries
      nodejs \
      # HTML to PDF conversion
      # ttf-ubuntu-font-family \
      # wkhtmltopdf \
      # Image Resizing
      imagemagick \
      vips \
      # Nice to have
      bash \
      git \
      vim \
      # Fixes watch file issues with things like HMR
      libnotify-dev

# Install any extra dependencies via Aptfile - These are installed on Heroku
# COPY Aptfile /usr/src/app/Aptfile
# RUN apk add --update $(cat /usr/src/app/Aptfile | xargs)

FROM builder AS development

# Set common ENVs
ARG USER_ID=${USER_ID:-1000}
ARG GROUP_ID=${GROUP_ID:-1000}
ARG DOCKER_USER=${DOCKER_USER:-appuser}
ARG BOOTSNAP_CACHE_DIR=${BOOTSNAP_CACHE_DIR:-/usr/src/bootsnap}

# Add non-root user and group with alpine first available uid, 1000
RUN addgroup -g $GROUP_ID -S $GROUP_ID \
  && adduser --disabled-password -G $GROUP_ID --uid $USER_ID -S $DOCKER_USER

# Create app directory in conventional, existing dir /usr/src
RUN mkdir -p /usr/src/app \
  && mkdir -p /usr/src/app/node_modules \
  && mkdir -p /usr/src/app/tmp/cache \
  && mkdir -p /usr/src/app/public/assets \
  && mkdir -p /usr/src/app/public/packs \
  && mkdir -p /usr/src/app/storage \
  && mkdir -p $BOOTSNAP_CACHE_DIR \
  && chown -R $USER_ID:$GROUP_ID /usr/src/app \
  && chown -R $USER_ID:$GROUP_ID $BOOTSNAP_CACHE_DIR
WORKDIR /usr/src/app

# Define the user running the container
USER $DOCKER_USER

ENV PATH /usr/src/app/bin:$PATH

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM development AS production

COPY Gemfile /usr/src/app
COPY .ruby-version /usr/src/app
COPY Gemfile.lock /usr/src/app

# Install Ruby Gems
RUN bundle config set deployment 'true' \
  && bundle config set without 'development:test' \
  && bundle check || bundle install --jobs=$(nproc)

COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app

# Install Yarn Libraries
RUN yarn install --check-files

# Copy the rest of the app
COPY --chown=$DOCKER_USER . /usr/src/app

# Precompile the assets & Bootsnap
RUN RAILS_SERVE_STATIC_FILES=enabled \
      SECRET_KEY_BASE=secret-key-base \
      RAILS_ENV=production \
      RACK_ENV=production \
      NODE_ENV=production \
      bundle exec rake assets:precompile \
      && bundle exec bootsnap precompile --gemfile app/ lib/
