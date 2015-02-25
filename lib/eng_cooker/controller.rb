module EngCooker
  class Controller < Thor
    include Thor::Actions

    # make command
    option :en, desc: 'English text.', type: :string
    option :ja, desc: 'Japanese text.', type: :string
    desc 'make', 'Save a sentence in the database.'

    def make
      en_text = options[:en] || ask('English text:')
      ja_text = options[:ja] || ask('Japanese text:')
      Sentence.create(en_text, ja_text)

      puts 'Make successful.'
    end

    # question command
    option :id, desc: 'Question id.', type: :numeric
    desc 'question', 'Set a question for a sentence in the database.'

    def question
      maked_question = Question.make(options[:id])
      fail '問題文が見つかりませんでした。' if maked_question.nil?
      hidden_answer = maked_question.hidden_answer

      loop do
        puts maked_question.examination
        puts "> #{hidden_answer}"
        user_answer = ask('>')
        puts ''

        # 正解したら、ループを終える
        break if maked_question.correct?(user_answer)

        hidden_answer = maked_question.show_partial_answer(user_answer)
      end
    end

    # list command
    desc 'list', 'Show sentences in the database'

    def list
      Sentence.all.each do |sentence|
        puts "#{sentence.id}, #{sentence.ja_text}"
      end
    end
  end
end
