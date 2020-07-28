require 'sidekiq/web'
require 'sidekiq/cron/web'

# https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
end

if Sidekiq.server?
  Rails.application.config.after_initialize do
    schedule_file = Rails.root.join('config', 'schedule.yml')

    # Use https://crontab.guru to confirm times
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if schedule_file.exist?
  end
end

Sidekiq.configure_client do |_config|
  # Any client specific configuration
end

# Setup the CacheStore & ActiveJob to use Redis otherwise fallback to doing things inline.
if ENV['REDIS_URL'].present?
  Rails.application.config.cache_store = :redis_cache_store, {
    url: ENV['REDIS_URL'],
    network_timeout: 5
  }
  Rails.application.config.active_job.queue_adapter = :sidekiq
else
  Rails.application.config.active_job.queue_adapter = :inline
end
