require 'spec_helper'

describe Cubits do
  context 'class methods,' do
    subject { described_class }

    it { is_expected.to respond_to(:available?) }
    it { is_expected.to respond_to(:send_money) }
    it { is_expected.to respond_to(:buy) }
    it { is_expected.to respond_to(:sell) }
  end # class methods
end # describe Cubits::Account
