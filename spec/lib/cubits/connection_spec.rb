require 'spec_helper'

describe Cubits::Connection do
  let(:key) { 'blablaKEY' }
  let(:secret) { 'blablaSECRET' }

  subject { described_class.new(key: key, secret: secret) }

  it { is_expected.to respond_to(:get) }
  it { is_expected.to respond_to(:post) }

end # describe Cubits::Connection
