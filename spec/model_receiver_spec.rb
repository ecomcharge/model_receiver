require 'spec_helper'

describe ModelReceiver do

  describe "#modify" do
    let(:params) { { 'shops' => attributes } }
    let(:model)  { described_class.new(params) }
    let(:attributes) { {'id' => 1, 'name' => 'test'} }
    let(:attrs_for_update) { {'name' => 'test'} }

    context "when model class exists" do
      let(:orm_proxy) { double('orm_proxy') }

      it "calls update_db method of ORMProxy" do
        expect(ORMProxy).to receive(:build).with('shops', attributes).and_return(orm_proxy)
        expect(orm_proxy).to receive(:update_db)

        model.modify
      end
    end

    context "when parameters don't contain model name" do
      let(:params) { {} }

      it "sets error" do
        model.modify

        expect(model.error).to eq("Can't recognize model name")
      end
    end
  end

  describe "#has_error?" do
    let(:model) { described_class.new({}) }
    subject { model.has_error? }

    context "when model has error" do
      before  { model.send(:add_error, 'error') }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when model hasn't error" do
      it "returns false" do
        expect(subject).to be false
      end
    end
  end

  describe "#error" do
    let(:model) { described_class.new({}) }

    before { model.instance_variable_set(:@errors, ['Error1', 'Error2']) }

    it "returns error" do
      expect(model.error).to eq('Error1. Error2')
    end
  end
end
