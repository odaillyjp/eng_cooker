require 'spec_helper'

module EngCooker
  describe Sentence do
    let(:sentence) do
      Sentence.new(
        en_text: 'She sells seashells by the seashore.',
        ja_text: '彼女は海岸で貝殻を売ります。')
    end

    # class methods

    context '英文が1つ保存されているとき' do
      before :all do
        @created_sentence = Sentence.create('I am bread.', '私はパンです。')
      end

      after :all do
        EngCooker.configuration.database.truncate!
      end

      describe '.all' do
        it 'その英文だけを持つ配列を返すこと' do
          expect(Sentence.all).to eq [@created_sentence]
        end
      end

      describe '.find' do
        context '存在しないid番号を渡したとき' do
          it 'nilを返すこと' do
            expect(Sentence.find(0)).to be_nil
            expect(Sentence.find(2)).to be_nil
          end
        end

        context '1を渡したとき' do
          it 'idに1を持つ英文を返すこと' do
            expect(Sentence.find(1).id).to eq 1
          end
        end
      end

      describe '.sample' do
        it 'その英文を返すこと' do
          expect(Sentence.sample).to eq @created_sentence
        end
      end
    end

    context '英文が2つ保存されているとき' do
      before :all do
        @created_sentences = [
          Sentence.create('I came to like him.', '彼を好きになりました。'),
          Sentence.create('I feel like having a drink tonight.', '今晩、飲みたいよ。')]
      end

      after :all do
        EngCooker.configuration.database.truncate!
      end

      describe '.all' do
        it '保存された2つの英文だけを持つ配列を返すこと' do
          expect(Sentence.all).to eq @created_sentences
        end
      end

      describe '.find' do
        context '存在しないid番号を渡したとき' do
          it 'nilを返すこと' do
            expect(Sentence.find(0)).to be_nil
            expect(Sentence.find(3)).to be_nil
          end
        end

        context '1を渡したとき' do
          it 'idに1を持つ英文を返すこと' do
            expect(Sentence.find(1).id).to eq 1
          end
        end
      end

      describe '.sample' do
        it '2つの英文の内、1つの英文を返すこと' do
          expect(Sentence.sample).to be_in(@created_sentences)
        end
      end
    end

    # public methods

    describe '#hide_en_text' do
      it '英文の中のアルファベットを"_"に変換した文字列を返すこと' do
        expect(sentence.hide_en_text).to eq '___ _____ _________ __ ___ ________.'
      end
    end

    # private methods

    describe '#split_word' do
      it '英文の中で使われている単語を配列で返すこと' do
        words = sentence.send(:split_word, sentence.en_text)
        expect(words).to eq %w(She sells seashells by the seashore)
      end
    end
  end
end
