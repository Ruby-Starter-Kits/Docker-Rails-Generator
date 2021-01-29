Rails.application.config do
  if Rails.env.development?
    config.logger = ActiveSupport::Logger.new(config.paths['log'].first, 1, 50.megabytes)
  end
end
