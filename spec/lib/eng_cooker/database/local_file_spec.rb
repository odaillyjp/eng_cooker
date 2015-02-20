require 'spec_helper'
require 'eng_cooker/database/local_file'

module EngCooker
  describe Sentence do
    let(:sentence) do
      Sentence.new(
        en_text: 'I had expected you to answer.',
        ja_text: 'あなたに答えて欲しかった')
    end

    subject { sentence }

    before do
      allow(Time).to receive(:now).and_return(Time.parse('2015/1/1 12:00:00'))
    end

    describe '#to_h' do
      it 'should return the sentence hash' do
        hash = sentence.to_h
        expect(hash[:en_text]).to eq 'I had expected you to answer.'
        expect(hash[:ja_text]).to eq 'あなたに答えて欲しかった'
        expect(hash[:created_at]).to eq Time.parse('2015/1/1 12:00:00')
      end
    end
  end

  describe Database::LocalFile do
    it_should_behave_like 'a database strategy', EngCooker::Database::LocalFile
  end
end
