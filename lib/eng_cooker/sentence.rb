module EngCooker
  class Sentence
    attr_reader :en_text, :ja_text, :words

    def self.all
      sentences = EngCooker.configuration.database.get_all
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

    private

    def split_word(en_text)
      en_text.split(/[\s\r\n,.:;"()]+/)
    end
  end
end
