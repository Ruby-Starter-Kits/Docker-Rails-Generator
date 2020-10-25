FROM ruby:2.7.1-alpine AS builder

LABEL maintainer="Mike Rogers <me@mikerogers.io>"

RUN apk add --no-cache \
    #
    # required
    build-base libffi-dev \
    nodejs yarn tzdata \
    postgresql-dev zlib-dev libxml2-dev libxslt-dev readline-dev bash \
    # Nice to haves
    git vim \
    #
    # Fixes watch file issues with things like HMR
    libnotify-dev

FROM builder as development

# Create a non-root user
# Otherwise folders like node_modules are owned by root.
ARG USER_ID=${USER_ID:-1000}
ARG GROUP_ID=${GROUP_ID:-1000}
ARG DOCKER_USER=${DOCKER_USER:-user}

RUN addgroup -g $GROUP_ID -S $GROUP_ID
RUN adduser --disabled-password -G $GROUP_ID --uid $USER_ID -S $DOCKER_USER

# Add the current apps files into docker image
RUN mkdir -p /usr/src/app
RUN chown -R $USER_ID:$GROUP_ID /usr/src/app
WORKDIR /usr/src/app

# Install any extra dependencies via Aptfile - These are installed on Heroku
# COPY Aptfile /usr/src/app/Aptfile
# RUN apk add --update $(cat /usr/src/app/Aptfile | xargs)

ENV PATH /usr/src/app/bin:$PATH

# Install latest bundler
RUN bundle config --global silence_root_warning 1

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# Define the user running the container
USER $USER_ID:$GROUP_ID

FROM development AS shared-production

COPY Gemfile /usr/src/app
COPY .ruby-version /usr/src/app
COPY Gemfile.lock /usr/src/app

COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app

FROM shared-production AS ci

# Install Ruby Gems
RUN bundle check || bundle install --jobs=$(nproc)

# Install Yarn Libraries
RUN yarn install --check-files

# Copy the rest of the app
COPY . /usr/src/app

CMD ["bundle", "exec", "rspec"]

FROM shared-production AS production

# Install Ruby Gems
RUN bundle config set deployment 'true'
RUN bundle config set without 'development:test'
RUN bundle check || bundle install --jobs=$(nproc)

# Install Yarn Libraries
RUN yarn install --check-files

# Copy the rest of the app
COPY . /usr/src/app

# Compile the assets
RUN RAILS_SERVE_STATIC_FILES=enabled SECRET_KEY_BASE=secret-key-base RAILS_ENV=production RACK_ENV=production NODE_ENV=production bundle exec rake assets:precompile
