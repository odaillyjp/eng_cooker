module EngCooker
  module Database
    require 'json'

    class LocalFile
      def initialize(storage_path: 'db/sentences.json')
        @storage_path = [APP_ROOT, storage_path].join('/')
        @sentences = load_storage_file
      end

      def set(data)
        @sentences.push(data.to_h)
        File.open(@storage_path, 'w') { |file| file.write(@sentences.to_json) }
      end

      def sample
        @sentences.sample
      end

      def find_all
        @sentences
      end

      def truncate!
        @sentences = []
        File.open(@storage_path, 'w') { |file| file.write(@sentences.to_json) }
      end

      private

      def load_storage_file
        if File.exist?(@storage_path)
          JSON.parse(File.read(@storage_path)).map(&:symbolize_keys)
        else
          []
        end
      rescue JSON::ParserError
        raise StorageLoadError, 'データベースファイルの解析に失敗しました。'
      end
    end

    class StorageLoadError < StandardError; end
  end

  Sentence.class_eval do
    def to_h
      { en_text: @en_text, ja_text: @ja_text, created_at: Time.now }
    end
  end
end
