require 'spec_helper'

describe Cubits::Callback do
  let(:key) { '7287ba0902461025b01d5b99e4679018' }
  let(:secret) { '93yJJ8LBDe3zNSewHBdX1XIQDjCMDIn0EKNnXrd3kfzL72fvLz99uKnXFLYuCfkt' }
  let!(:configured_connection) do
    Cubits.configure(key: key, secret: secret)
  end

  let(:cubits_key) { '7287ba0902461025b01d5b99e4679018' }
  let(:cubits_callback_id) { 'ABCDEFGH' }
  let(:cubits_signature) { '7d89c35c2e0840867f63b77ea575050db21a134b674d4a38f1e255518efb5b81383442cd9a888dca86dfe3e43a0769525088aac3efed3102a6b14bd1446f14a1' }
  let(:body) { '{"attr1": 123, "attr2": "hello"}' }
  let(:resource_class) { Cubits::Invoice }
  let(:allow_insecure) { nil }

  context '.from_params(),' do
    let(:params) do
      {
        cubits_key: cubits_key,
        cubits_callback_id: cubits_callback_id,
        cubits_signature: cubits_signature,
        body: body,
        resource_class: resource_class,
        allow_insecure: allow_insecure
      }
    end

    subject { described_class.from_params(params) }

    it 'raises no errors for valid params' do
      expect { subject }.to_not raise_error
    end

    it 'returns a Resource instance' do
      expect(subject).to be_a Cubits::Resource
    end

    it 'uses the request body to initialize the Resource instance' do
      expect(subject.attr1).to eq 123
      expect(subject.attr2).to eq 'hello'
    end

    context 'when callback is NOT signed,' do
      let(:cubits_key) { nil }
      let(:cubits_signature) { nil }

      it 'refuses to process callback' do
        expect { subject }.to raise_error(Cubits::InsecureCallback)
      end

      context 'and insecure callbacks are explicitly allowed,' do
        let(:allow_insecure) { true }
        it 'processes the unsigned callback' do
          expect { subject }.to_not raise_error
        end
      end # and insecure callbacks are explicitly allowed
    end # when callback is NOT signed

    context 'when callback has an invalid signature,' do
      let(:cubits_signature) { 'blablabla' }
      it 'refuses to process callback' do
        expect { subject }.to raise_error(Cubits::InvalidSignature)
      end
    end # when callback has an invalid signature

    context 'when callback has an invalid API key,' do
      let(:cubits_key) { 'blablabla' }
      it 'refuses to process callback' do
        expect { subject }.to raise_error(Cubits::InvalidSignature)
      end
    end # when callback has an invalid API key

    context 'when no :resource_class is specified,' do
      let(:resource_class) { nil }
      it 'returns a Hash' do
        expect(subject).to be_a Hash
        expect(subject).to eq({ 'attr1' => 123, 'attr2' => 'hello' })
      end
    end # when no :resource_class is specified
  end # .from_params()
end # describe Cubits::Connection
