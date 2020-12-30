require 'net/http'
require 'uri'

def open(url)
  Net::HTTP.get(URI.parse(url))
end

base_uri = 'https://raw.githubusercontent.com/Ruby-Starter-Kits/Docker-Rails-Generator/feature/copy-command/'

files = [
  '.dockerignore',
  'docker-compose.ci.yml',
  'docker-compose.yml',
  'Dockerfile',
]

files.each do |file_path|
  file 'docker-compose.ci.yml', open("#{base_uri}#{file_path}")
end
