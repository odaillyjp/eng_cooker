require 'spec_helper'

module EngCooker
  describe Sentence do
    let(:sentence) do
      Sentence.new(
        'She sells seashells by the seashore.',
        '彼女は海岸で貝殻を売ります。')
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
