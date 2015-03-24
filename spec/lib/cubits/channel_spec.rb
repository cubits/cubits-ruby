require 'spec_helper'

describe Cubits::Channel do
  context 'class methods,' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
    it { is_expected.to respond_to(:find) }
  end # class methods

  it { is_expected.to respond_to(:update) }
  it { is_expected.to respond_to(:reload) }
end # describe Cubits::Channel
