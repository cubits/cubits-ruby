require 'spec_helper'

describe Cubits do
  let(:key) { 'blablakey' }
  let(:secret) { 'blablasecret' }

  context '.configure' do
    it 'fails if key is missing' do
      expect { Cubits.configure(secret: secret) }.to raise_error
    end

    it 'fails if secret is missing' do
      expect { Cubits.configure(key: key) }.to raise_error
    end

    it 'runs without errors if key and secret are present' do
      expect { Cubits.configure(key: key, secret: secret) }.to_not raise_error
    end
  end # .configure

  context '.connection' do
    subject { Cubits.connection }

    it 'fails when connection is not configured' do
      expect { subject }.to raise_error
    end

    it 'returns Connection object when connection is configured' do
      Cubits.configure(key: key, secret: secret)
      expect { subject }.to_not raise_error
      expect(subject).to be_a Cubits::Connection
    end
  end # .connection

  context '.logger' do
    subject { Cubits.logger }

    it { is_expected.to be_a Logger }
  end # .logger

end # describe Cubits
