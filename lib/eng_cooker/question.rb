module EngCooker
  class Question
    attr_reader :examination, :hint, :answer

    def self.make
      Question.new(Sentence.sample)
    end

    def initialize(sentence)
      @examination = sentence.ja_text
      @hint = sentence.filter_en_text
      @answer = sentence.en_text
    end

    def check_answer(user_answer)
      # 問題の答えとユーザーの回答を比べて、一致していない文字を'_'に変換文字列を返す
      #
      # ex.
      #   問題の答え (@answer)         = 'abcdef'
      #   ユーザーの回答 (user_answer) = 'axcxxf'
      #   返り値                       = 'a_c__f'
      #
      [@answer.chars, user_answer.chars].transpose
        .map { |chars| chars.first == chars.last ? chars.first : '_' }
        .join
    end
  end
end
