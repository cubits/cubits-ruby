require 'spec_helper'

describe Cubits do
  let(:key) { 'blablakey' }
  let(:secret) { 'blablasecret' }

  let(:another_key) { 'another_cubits_api_key' }
  let(:another_secret) { 'another_cubits_api_secret' }

  after { Thread.current[:cubits_active_connection_key] = nil }

  context '.configure' do
    it 'fails if key is missing' do
      expect { Cubits.configure(secret: secret) }.to raise_error(
        ArgumentError, 'String is expected as :key'
      )
    end

    it 'fails if secret is missing' do
      expect { Cubits.configure(key: key) }.to raise_error(
        ArgumentError, 'String is expected as :secret'
      )
    end

    it 'runs without errors if key and secret are present' do
      expect { Cubits.configure(key: key, secret: secret) }.to_not raise_error
    end
  end # .configure

  context '.connection' do
    subject { Cubits.connection }

    it 'fails when connection is not configured' do
      expect { subject }.to raise_error(
        Cubits::ConnectionError, 'Cubits connection is not configured for key (default)'
      )
    end

    it 'returns Connection object when connection is configured', :aggregate_failures do
      Cubits.configure(key: key, secret: secret)
      expect { subject }.to_not raise_error
      expect(subject).to be_a Cubits::Connection
      expect(subject.instance_variable_get(:@key)).to eql(key)
    end

    it 'returns Connection object by active connection key', :aggregate_failures do
      Cubits.configure(key: another_key, secret: another_secret)
      expect(Cubits).to receive(:active_connection_key).and_return(another_key)
      expect(subject).to be_a Cubits::Connection
      expect(subject.instance_variable_get(:@key)).to eql(another_key)
    end
  end # .connection

  context '.logger' do
    subject { Cubits.logger }

    it { is_expected.to be_a Logger }
  end # .logger

  describe '.active_connection_key=' do
    it 'does not allow to set the key when there are no configured connections' do
      expect { Cubits.active_connection_key = '123' }.to raise_exception(
        Cubits::ConnectionError, 'Cubits connection is not configured for key 123'
      )
    end

    it 'does not allow to set the key of non-existent connection' do
      Cubits.configure(key: key, secret: secret)
      expect { Cubits.active_connection_key = '123' }.to raise_exception(
        Cubits::ConnectionError, 'Cubits connection is not configured for key 123'
      )
    end

    it 'allows to set the key of the existing connection', :aggregate_failures do
      Cubits.configure(key: key, secret: secret)
      Cubits.configure(key: another_key, secret: another_secret)
      expect { Cubits.active_connection_key = key }.to_not raise_exception
      expect { Cubits.active_connection_key = another_key }.to_not raise_exception
    end

    it 'sets cubits_active_connection_key thread variable' do
      Cubits.configure(key: key, secret: secret)
      Cubits.active_connection_key = key
      expect(Thread.current[:cubits_active_connection_key]).to eql(key)
    end
  end # .active_connection_key=

  describe '.active_connection_key' do
    it 'returns thread-local connection key if exists' do
      Cubits.configure(key: key, secret: secret)
      Cubits.configure(key: another_key, secret: another_secret)
      Cubits.active_connection_key = key
      expect(Cubits.active_connection_key).to eql(key)
    end

    it 'returns the last configured connection key otherwise' do
      Cubits.configure(key: key, secret: secret)
      Cubits.configure(key: another_key, secret: another_secret)
      expect(Cubits.active_connection_key).to eql(another_key)
    end

    it 'returns nil if there are no configured connections' do
      expect(Cubits.active_connection_key).to be_nil
    end
  end # .active_connection_key

  describe '.with_connection_key' do
    it 'toggles active connection key' do
      Cubits.configure(key: key, secret: secret)
      Cubits.configure(key: another_key, secret: another_secret)

      Cubits.active_connection_key = key

      Cubits.with_connection_key(another_key) do
        expect(Cubits.active_connection_key).to eql(another_key)
      end

      expect(Cubits.active_connection_key).to eql(key)
    end
  end # .with_connection_key
end # describe Cubits
