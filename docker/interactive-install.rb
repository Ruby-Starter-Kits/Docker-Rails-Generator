require "readline"

@app_path = "App"

@arguments = [
  "--database=postgresql",
  "--webpack=stimulus",
  "--skip-bundle"
].join(' ')

# Confirm the app name
new_app_path = Readline.readline("Please confirm your app_path (Default is #{@app_path}): ", true)

if new_app_path != ""
  @app_path = new_app_path
end

system("rails new #{@app_path} #{@arguments}")
