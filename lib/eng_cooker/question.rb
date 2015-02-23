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
      user_sentence = Sentence.new(en_text: user_answer)

      if @sentence.words.size > user_sentence.words.size
        # ユーザーの回答の単語数が少ない場合、不足分をダミーの単語で埋める
        deficient_word_count = @sentence.words.size - user_sentence.words.size
        lengthen_answer = [user_answer, ' _' * deficient_word_count].join
        user_sentence = Sentence.new(en_text: lengthen_answer)
      else
        # ユーザーの回答の単語数が多い場合、超過分の単語を削る
        shorten_answer = user_sentence.words[0...@sentence.words.size].join(' ')
        user_sentence = Sentence.new(en_text: shorten_answer)
      end

      result_words = [@sentence.words, user_sentence.words].transpose
        .map do |(answer_word, user_answer_word)|
          if answer_word.downcase == user_answer_word.downcase
            answer_word
          elsif answer_word.size < user_answer_word.size
            '_' * answer_word.size
          else
            answer_word.chars.map.with_index { |answer_char, idx|
              answer_char == user_answer_word[idx] ? answer_char : '_'
            }.join
          end
        end

      hidden_answer.gsub(/_+/, '%s') % result_words
    end
  end
end
