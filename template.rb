require 'open-uri'

base_uri = 'https://raw.githubusercontent.com/Ruby-Starter-Kits/Docker-Rails-Generator/master/App-Template/'

files = [
  '.github/workflows/tests.yml',
  'config/cable.yml',
  'config/database.yml',
  '.dockerignore',
  'docker-compose.ci.yml',
  'docker-compose.yml',
  'Dockerfile',
]

files.each do |file_path|
  file file_path, URI.open("#{base_uri}#{file_path}").read
end

run("docker-compose build") if yes?("Build Docker Image?")
run("docker-compose run --rm web bin/setup") if yes?("Run bin/setup within your new container?")
