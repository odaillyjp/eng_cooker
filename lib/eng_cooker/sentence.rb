module EngCooker
  class Sentence
    attr_reader :en_text, :ja_text, :words

    def self.create(en_text, ja_text)
      sentence = Sentence.new(en_text: en_text, ja_text: ja_text)
      sentence.save
      sentence
    end

    def self.all
      sentences = EngCooker.configuration.database.find_all
      sentences.map { |sentence| Sentence.new(sentence.slice(:en_text, :ja_text)) }
    end

    def self.sample
      sentence = EngCooker.configuration.database.sample
      return nil if sentence.nil?
      Sentence.new(sentence.slice(:en_text, :ja_text))
    end

    def initialize(en_text: '', ja_text: '')
      @en_text = en_text
      @ja_text = ja_text
      @words = split_word(en_text)
    end

    def save
      EngCooker.configuration.database.set(self)
    end

    def ==(other)
      # 英文と日本語訳文が同じならば、同一だとみなす
      return false unless other.is_a?(Sentence)
      return false if en_text != other.en_text
      return false if ja_text != other.ja_text
      true
    end

    private

    def split_word(en_text)
      en_text.split(/[\s\r\n,.:;"()]+/)
    end
  end
end
