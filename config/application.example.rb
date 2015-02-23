EngCooker.configure do |config|
  config.database_adapter = 'local_file'
  config.database_options = { storage_path: 'db/sentences.json' }

  # Firebaseの場合
  # config.database_adapter = 'firebase'
  # config.database_options = { app_name: 'example' }
end
