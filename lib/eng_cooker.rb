require 'eng_cooker/sentence'

module EngCooker
  APP_ROOT = File.expand_path('../', __dir__)

  def self.configuration
    @configuration ||= EngCooker::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
    configuration.setting
  end
end
