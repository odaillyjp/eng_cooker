require 'eng_cooker/cofiguration'
require 'eng_cooker/sentence'
require 'eng_cooker/question'

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
