require 'spec_helper'

module EngCooker
  describe Question do
    context '英文が1つ保存されているとき' do
      before :all do
        @sentence = Sentence.create('Lorem ipsum.', 'テスト。')
      end

      after :all do
        EngCooker.configuration.database.truncate!
      end

      # class methods

      describe '.make' do
        it 'その英文を使った問題を返すこと' do
          maked_question = Question.make
          expect(maked_question.examination).to eq 'テスト。'
          expect(maked_question.hint).to eq '_____ _____.'
          expect(maked_question.answer).to eq 'Lorem ipsum.'
        end
      end

      # public methods

      describe '#check_answer' do
        context '答えが"Lorem ipsum."の問題に対して、"Loxxm ixsxx."を渡してとき' do
          it '"Lo__m i_s__."という文字列を返すこと' do
            expect(Question.make.check_answer('Loxxm ixsxx.')).to eq 'Lo__m i_s__.'
          end
        end
      end
    end
  end
end
