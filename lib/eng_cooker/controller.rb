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
    desc 'question', 'Set a question for a sentence in the database.'

    def question
      maked_question = Question.make
      puts maked_question.examination
      puts "> #{maked_question.hint}"

      loop do
        user_answer = ask('>')
        hint = maked_question.check_answer(user_answer)

        puts maked_question.examination
        puts "> #{hint}"
      end
    end
  end
end
