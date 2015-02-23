module EngCooker
  require 'forwardable'

  class Question
    extend Forwardable

    def_delegator :@sentence, :ja_text,      :examination
    def_delegator :@sentence, :hide_en_text, :hidden_answer
    def_delegator :@sentence, :en_text,      :answer

    def self.make
      Question.new(Sentence.sample)
    end

    def initialize(sentence)
      @sentence = sentence
    end

    def correct?(user_answer)
      answer == user_answer
    end

    # 問題の答えとユーザーの回答を比べて、正解している部分だけを表示した文字列を返す
    #
    # ex.
    #   question.answer # => 'abcdef'
    #   question.show_partial_answer('axcxxf') # => 'a_c__f'
    #
    def show_partial_answer(user_answer)
      if answer.size > user_answer.size
        # ユーザーの回答の文字数が少ないときは、不足分を隠れた答えで埋める
        user_answer.concat(hidden_answer[-(answer.size - user_answer.size)..-1])
      elsif answer.size < user_answer.size
        # ユーザーの回答の文字数が多いときは、超過分の文字を削る
        user_answer = user_answer[0...answer.size]
      end

      [answer.chars, user_answer.chars].transpose
        .map
        .with_index { |(answer_char, user_answer_char), idx|
          answer_char.downcase == user_answer_char.downcase ? answer_char : hidden_answer[idx]
        }.join
    end
  end
end
