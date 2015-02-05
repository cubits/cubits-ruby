require 'spec_helper'

describe Cubits::Account do
  context 'class methods,' do
    subject { described_class }

    it { is_expected.to respond_to(:all) }
  end # class methods
end # describe Cubits::Account
