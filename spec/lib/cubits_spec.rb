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

    context 'with concurrent connection' do
      let(:another_key) { 'another_cubits_api_key' }
      let(:another_secret) { 'another_cubits_api_secret' }
      before { Cubits.configure key: another_key, secret: another_secret }

      it 'returns connection object by active connection key' do
        expect(Cubits).to receive(:active_connection_key).and_return(another_key)
        expect(subject).to be_a Cubits::Connection
        expect(subject.instance_variable_get(:@key)).to eq(another_key)
      end
    end
  end # .connection

  context '.logger' do
    subject { Cubits.logger }

    it { is_expected.to be_a Logger }
  end # .logger

  describe '.active_connection_key=' do
    it 'sets cubits_active_connection_key thread variable' do
      Cubits.active_connection_key = key
      expect(Thread.current[:cubits_active_connection_key]).to eq(key)
    end
  end # .active_connection_key=

  describe '.active_connection_key' do
    it 'returns cubits_active_connection_key thread variable' do
      Thread.current[:cubits_active_connection_key] = key
      expect(Cubits.active_connection_key).to eq(key)
    end
  end # .active_connection_key

  describe '.with_connection_key' do
    let(:another_key) { 'another_cubits_api_key' }


    it 'toggles active connection key' do
      Cubits.active_connection_key = key

      Cubits.with_connection_key another_key do
        expect(Cubits.active_connection_key).to eq(another_key)
      end

      expect(Cubits.active_connection_key).to eq(key)
    end
  end # .with_connection_key
end # describe Cubits
