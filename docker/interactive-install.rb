require "readline"

@app_path = "App"

@arguments = [
  "--database=postgresql",
  "--skip-bundle",
  "--skip-webpack-install"
].join(' ')

# Install rails
system("rails new #{@app_path} #{@arguments}")

# Remove the files which often are confusing to newbies.
system("rm /usr/src/app/#{@app_path}/config/credentials.yml.enc") 
system("rm /usr/src/app/#{@app_path}/config/master.key") 
system("rm /usr/src/app/#{@app_path}/config/database.yml") 

# Copy the docker files
system("cp -ra /usr/src/App-Template/* /usr/src/app/#{@app_path}/")

# Copy the hidden files
system("cp -ra /usr/src/App-Template/.env.sample /usr/src/app/#{@app_path}/.env.sample")
system("cp -ra /usr/src/App-Template/.dockerignore /usr/src/app/#{@app_path}/.dockerignore")

# Copy sample files
system("cp -ra /usr/src/App-Template/.env.sample /usr/src/app/#{@app_path}/.env")
system("cp -ra /usr/src/App-Template/config/database.yml.sample /usr/src/app/#{@app_path}/config/database.yml")
