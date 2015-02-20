module EngCooker
  class Configuration
    attr_reader :database
    attr_writer :database_adapter, :database_options

    def initialize
      @database_adapter = 'local_file'
      @database_options = {}
    end

    def setting
      configure_database(@database_adapter)
    end

    private

    def configure_database(database_name)
      require_relative("database/#{database_name}")
      @database = EngCooker::Database.const_get(database_name.classify).new(@database_options)
    end
  end
end
