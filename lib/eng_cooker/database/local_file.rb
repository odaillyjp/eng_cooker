module EngCooker
  module Database
    require 'json'

    # 注意: このクラスは複数のプロセスやスレッドから同時に使うことを想定していない
    class LocalFile
      def initialize(storage_path: 'db/sentences.json')
        @storage_path = [APP_ROOT, storage_path].join('/')
        @sentences = load_storage_file
        @last_id = if @sentences.present?
                     last_sentence = @sentences.max_by { |sentence| sentence[:id] }
                     last_sentence[:id]
                   else
                     0
                   end
      end

      def set(data)
        if data.id.nil?
          @last_id += 1
          data.id = @last_id
        end

        @sentences.push(data.to_h)
        File.open(@storage_path, 'w') { |file| file.write(@sentences.to_json) }
      end

      def find_all
        @sentences
      end

      def find(sentence_id)
        find_by_bsearch(sentence_id)

        # 注意: IDが昇順で並んでいるのでバイナリサーチが可能だが,
        #　　　 昇順ではなくなった場合はバイナリサーチができないので,
        #　　　 このメソッドは正しく動かなくなる.
        #       その場合は、処理を以下のように修正すること.
        #
        # @sentences.find { |sentence| sentence[:id] == sentence_id }
      end

      def sample
        @sentences.sample
      end

      def truncate!
        @sentences = []
        File.open(@storage_path, 'w') { |file| file.write(@sentences.to_json) }
        @last_id = 0
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

      def find_by_bsearch(sentence_id, from: 0, to: (@sentences.size - 1))
        return nil if from > to

        # バイナリサーチで該当のIDを持つ文を見つける
        middle_index = (from + to) / 2
        middle_id = @sentences[middle_index][:id]

        case middle_id <=> sentence_id
        when 1 then find_by_bsearch(sentence_id, from: from, to: (middle_index - 1))
        when 0 then @sentences[middle_index]
        when -1 then find_by_bsearch(sentence_id, from: (middle_index + 1), to: to)
        end
      end
    end

    class StorageLoadError < StandardError; end
  end

  Sentence.class_eval do
    def to_h
      { id: @id, en_text: @en_text, ja_text: @ja_text, created_at: Time.now }
    end
  end
end
