module EngCooker
  class Sentence
    attr_reader :en_text, :ja_text, :words

    def initialize(en_text, ja_text)
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
