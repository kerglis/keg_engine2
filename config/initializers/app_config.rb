AppConfig = ConfigSpartan.create do
  if File.exist?(Rails.root.join('config/app_config.yml'))
    file Rails.root.join('config/app_config.yml')
  end

  if File.exist?(Rails.root.join('config/environments', "#{Rails.env}.yml"))
    file Rails.root.join('config/environments', "#{Rails.env}.yml")
  end
end
