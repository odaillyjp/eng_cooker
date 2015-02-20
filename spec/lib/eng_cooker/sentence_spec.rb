require 'spec_helper'

module EngCooker
  describe Sentence do
    let(:sentence) do
      Sentence.new(
        en_text: 'She sells seashells by the seashore.',
        ja_text: '彼女は海岸で貝殻を売ります。')
    end

    context '英文が1つ保存されているとき' do
      before { sentence.save }
      after { EngCooker.configuration.database.truncate! }

      describe '.sample' do
        it 'その英文を返すこと' do
          sampling_sentence = Sentence.sample
          expect(sampling_sentence.en_text).to eq sentence.en_text
          expect(sampling_sentence.ja_text).to eq sentence.ja_text
        end
      end
    end

    # private methods

    describe '#split_word' do
      context '英文を渡したとき' do
        it '英文の中で使われている単語を配列で返すこと' do
          words = sentence.send(:split_word, sentence.en_text)
          expect(words).to eq %w(She sells seashells by the seashore)
        end
      end
    end
  end
end
