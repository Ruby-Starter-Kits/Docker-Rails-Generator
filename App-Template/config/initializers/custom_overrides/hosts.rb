# I'm a big fan of https://github.com/puma/puma-dev for turning on my local dev environment.
# So make sure our local environments play nicely with it.

Rails.application.configure do
  # config.hosts << ENV['URL'] if ENV['URL'].present?
  # config.hosts << /[a-z0-9.-]+\.herokuapp\.com/

  ## ActionCable also needs to accept requests from Puma Dev & Ngrok.
  # config.action_cable.allowed_request_origins = [
  #   /[a-z0-9.-]+\.ngrok\.io/,
  #   /[a-z0-9.-]+\.test/
  # ]
  # config.action_cable.allowed_request_origins << ENV['URL'] if ENV['URL'].present?

  ## Whitelist ngrok connections to development environment.
  # config.hosts << /[a-z0-9.-]+\.ngrok\.io/
  ## Whitelist Puma-Dev hostname.
  # config.hosts << /[a-z0-9.-]+\.test/

  ## Allow AWS health checks
  # config.hosts << /^\d+\.\d+\.\d+\.\d+/

  ## Test suite host
  # config.hosts << '.example.com' if Rails.env.test?
end
