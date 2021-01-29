if Rails.env.development?
  Rails.logger = ActiveSupport::Logger.new(Rails.application.config.paths['log'].first, 1, 50.megabytes)
end
