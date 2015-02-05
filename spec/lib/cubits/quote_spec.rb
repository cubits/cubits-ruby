require 'spec_helper'

describe Cubits::Quote do
  context 'class methods,' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end # class methods
end # describe Cubits::Quote
