require 'spec_helper'

module EngCooker::Database
  RSpec.shared_examples 'a database strategy' do |klass|
    let(:database) { klass.new }
    subject { database }

    it { is_expected.to be_respond_to(:set) }
    it { is_expected.to be_respond_to(:find_all) }
    it { is_expected.to be_respond_to(:find) }
    it { is_expected.to be_respond_to(:sample) }
    it { is_expected.to be_respond_to(:truncate!) }
  end
end
