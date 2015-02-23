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
          expect(maked_question.hidden_answer).to eq '_____ _____.'
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

      describe '#show_partial_answer' do
        context '答えと一致している部分がある文字列を渡したとき' do
          it '答えと一致していた部分だけを表示した答えを返すこと' do
            user_answer = 'Loxxm ixsxx xolor sit !?$#.'
            expect_answer = 'Lo__m i_s__ _olor sit ____.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '答えよりも文字数が少ない文字列を渡したとき' do
          it '不足分を隠れた答えで埋めた答えを返すこと' do
            user_answer = 'Loxxm ixsxx'
            expect_answer = 'Lo__m i_s__ _____ ___ ____.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '答えよりも文字数が多い文字列を渡したとき' do
          it '超過分を削った答えを返すこと' do
            user_answer = 'Lorem !?#$% dolor sit amet. foo bar buzz.'
            expect_answer = 'Lorem _____ dolor sit amet.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '区切り文字を間違えている文字列を渡したとき' do
          it '区切り文字を間違えている部分は"_"に変換しないこと' do
            user_answer = 'xoremxipsumxdolorxsitxametx'
            expect_answer = '_orem ipsum dolor sit amet.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '大文字と小文字を間違えている文字列を渡したとき' do
          it '大文字と小文字の区別はしないこと' do
            user_answer = 'lorem ipsum dxxxx sit amet.'
            expect_answer = 'Lorem ipsum d____ sit amet.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end
      end
    end
  end
end
