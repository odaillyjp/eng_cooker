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
          sampling_sentences = Sentence.all
          expect(sampling_sentences).to eq [@created_sentence]
        end
      end

      describe '.sample' do
        it 'その英文を返すこと' do
          sampling_sentence = Sentence.sample
          expect(sampling_sentence).to eq @created_sentence
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
          sampling_sentences = Sentence.all
          expect(sampling_sentences).to eq @created_sentences
        end
      end
    end

    # public methods

    describe '#filter_en_text' do
      it '英文の中のアルファベットを"_"に変換した文字列を返すこと' do
        expect(sentence.filter_en_text).to eq '___ _____ _________ __ ___ ________.'
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
