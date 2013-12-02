AppConfig = ConfigSpartan.create do
  file Rails.root.join("config/app_config.yml")                   if File.exists?(Rails.root.join("config/app_config.yml"))
  file Rails.root.join("config/environments", "#{Rails.env}.yml") if File.exists?(Rails.root.join("config/environments", "#{Rails.env}.yml"))
end