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
    end

    context '英文が"Lorem ipsum dolor sit amet."、訳文が"ダミーのテキストです。"の問題のとき' do
      let!(:sentence) do
        Sentence.new(
          en_text: 'Lorem ipsum dolor sit amet.',
          ja_text: 'ダミーのテキストです。')
      end

      let(:question) { Question.new(sentence) }

      # public methods

      describe '#check_answer' do
        context '"Loxxm ixsxx xolor sit !?$#."を渡したとき' do
          it '"Lo__m i_s__ _olor sit ____."という文字列を返すこと' do
            user_answer = 'Loxxm ixsxx xolor sit !?$#.'
            expect_answer = 'Lo__m i_s__ _olor sit ____.'
            expect(question.check_answer(user_answer)).to eq expect_answer
          end
        end
      end
    end
  end
end
