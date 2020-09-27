# Let break our locales into different files nested into subfiles

Rails.application.configure do
  config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.{rb,yml}"]
  config.i18n.fallbacks = true
end
