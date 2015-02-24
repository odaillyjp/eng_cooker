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

      describe '#correct?' do
        context '答えと完全一致している文字列を渡したとき' do
          it { expect(question.correct?(sentence.en_text)).to be_truthy }
        end

        context '答えと完全一致していない文字列を渡したとき' do
          it { expect(question.correct?('foo')).to be_falsy }
        end

        context '答えの文字を全て小文字に変換した文字列を渡したとき' do
          it '大文字と小文字を区別せずに判定すること' do
            expect(question.correct?(sentence.en_text.downcase)).to be_truthy
          end
        end
      end

      describe '#show_partial_answer' do
        context '答えと一致している部分がある文字列を渡したとき' do
          it '答えと一致していた部分だけを表示した答えを返すこと' do
            user_answer = 'Loxxm ixsxx xolor sit !?$#.'
            expect_answer = 'Lo__m i_s__ _olor sit ____.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '答えよりも単語数が少ない文字列を渡したとき' do
          it '不足分を隠し文字で埋めた答えを返すこと' do
            user_answer = 'Loxxm ixsxx'
            expect_answer = 'Lo__m i_s__ _____ ___ ____.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '答えよりも単語数が多い文字列を渡したとき' do
          it '超過分の単語を削った答えを返すこと' do
            user_answer = 'Lorem !?#$% dolor sit amet. foo bar buzz.'
            expect_answer = 'Lorem _____ dolor sit amet.'
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

        context '答えよりも文字数が少ない単語を含んだ文字列を渡したとき' do
          it '不足分を隠し文字で埋めた答えを返すこと' do
            user_answer = 'Lor i dol sit ame.'
            expect_answer = 'Lor__ i____ dol__ sit ame_.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end

        context '答えよりも文字数が多い単語を含んだ文字列を渡したとき' do
          it '文字数が多い単語は全て隠し文字に変えた答えを返すこと' do
            user_answer = 'Loremx ipsumxxx dxxxxolor sit amettt.'
            expect_answer = '_____ _____ _____ sit ____.'
            expect(question.show_partial_answer(user_answer)).to eq expect_answer
          end
        end
      end
    end
  end
end
