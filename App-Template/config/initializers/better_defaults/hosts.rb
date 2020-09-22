# Often you may need to whitelist the URL you use to access your local development environment (assuming you don't use 127.0.0.1).
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
