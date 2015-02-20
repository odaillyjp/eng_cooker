require 'bundler'
Bundler.require *%i(default test)

$LOAD_PATH.unshift(File.expand_path('../lib/', __dir__))
require 'eng_cooker'

EngCooker.configure do |config|
  config.database_adapter = 'local_file'
  config.database_options = { storage_path: 'db/sentences_test.json' }
end
