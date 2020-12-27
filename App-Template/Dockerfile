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
      git \
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
      linux-headers \
      # HTML to PDF conversion
      ttf-ubuntu-font-family \
      wkhtmltopdf \
      libreoffice \
      # Image Resizing
      imagemagick \
      vips \
      # Nice to have
      bash \
      git \
      vim \
      # Fixes watch file issues with things like HMR
      libnotify-dev


FROM builder AS development

# Create a non-root user
# Otherwise folders like node_modules are owned by root.
ARG USER_ID=${USER_ID:-1000}
ARG GROUP_ID=${GROUP_ID:-1000}
ARG DOCKER_USER=${DOCKER_USER:-user}
ARG BOOTSNAP_CACHE_DIR=${BOOTSNAP_CACHE_DIR:-/usr/src/bootsnap}

# Add non-root user and group with alpine first available uid, 1000
RUN addgroup -g $GROUP_ID -S $GROUP_ID
RUN adduser --disabled-password -G $GROUP_ID --uid $USER_ID -S $DOCKER_USER

# Create app directory in conventional, existing dir /usr/src
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/node_modules
RUN mkdir -p /usr/src/app/tmp/cache
RUN mkdir -p /usr/src/app/storage
RUN mkdir -p $BOOTSNAP_CACHE_DIR
RUN chown -R $USER_ID:$GROUP_ID /usr/src/app
RUN chown -R $USER_ID:$GROUP_ID $BOOTSNAP_CACHE_DIR
WORKDIR /usr/src/app

# Install any extra dependencies via Aptfile - These are installed on Heroku
# COPY Aptfile /usr/src/app/Aptfile
# RUN apk add --update $(cat /usr/src/app/Aptfile | xargs)

ENV PATH /usr/src/app/bin:$PATH

# Configure bundler
RUN bundle config --global silence_root_warning 1
RUN bundle config build.nokogiri --use-system-libraries

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# Define the user running the container
USER $USER_ID:$GROUP_ID

FROM development AS production

COPY --chown=$USER_ID:$GROUP_ID Gemfile /usr/src/app
COPY --chown=$USER_ID:$GROUP_ID .ruby-version /usr/src/app
COPY --chown=$USER_ID:$GROUP_ID Gemfile.lock /usr/src/app

COPY --chown=$USER_ID:$GROUP_ID package.json /usr/src/app
COPY --chown=$USER_ID:$GROUP_ID yarn.lock /usr/src/app

# Install Ruby Gems
RUN bundle config set deployment 'true'
RUN bundle config set without 'development:test'
RUN bundle check || bundle install --jobs=$(nproc)

# Install Yarn Libraries
RUN yarn install --check-files

# Copy the rest of the app
COPY --chown=$USER_ID:$GROUP_ID . /usr/src/app

# Precompile the assets
RUN RAILS_SERVE_STATIC_FILES=enabled SECRET_KEY_BASE=secret-key-base RAILS_ENV=production RACK_ENV=production NODE_ENV=production bundle exec rake assets:precompile

# Precompile Bootsnap
RUN RAILS_SERVE_STATIC_FILES=enabled SECRET_KEY_BASE=secret-key-base RAILS_ENV=production RACK_ENV=production NODE_ENV=production bundle exec bootsnap precompile --gemfile app/ lib/

# Tidy up installation
RUN apk update && apk del build-dependencies
