# Docker Rails Installer

A quick start for running [Ruby on Rails](https://rubyonrails.org/) with Docker.

## Sample Usage

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ruby-Starter-Kits/Docker-Rails-Installer/master/installer.sh)"
```

Install [Docker](https://hub.docker.com/editions/community/docker-ce-desktop-mac/) and paste the above snippet into a macOS Terminal or Linux shell prompt.

This will create a Docker ready version of Rails in the `App` folder.

## How this works

This will pull down [rubystarterkits/rails-installer](https://hub.docker.com/repository/docker/rubystarterkits/rails-installer/general) from docker, which contains everything required to create a rails app locally. Then it'll do `rails new App` & copy all the files required to run under docker into that directory.

The aim is to avoid requiring developers to setup ruby & any other dependencies to get started.

## TODO

* Assess if a auto-updating template repo could also work just as well
* Setup way to change the folder it's installed to.
* Include other "People always install this next" stuff like sidekiq.
