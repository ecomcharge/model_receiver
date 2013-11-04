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
        ORMProxy.should_receive(:build).with('shops', attributes).and_return(orm_proxy)
        orm_proxy.should_receive(:update_db)

        model.modify
      end
    end

    context "when parameters don't contain model name" do
      let(:params) { {} }

      it "sets error" do
        model.modify

        model.error.should == "Can't recognize model name"
      end
    end
  end

  describe "#has_error?" do
    context "when model has error" do
      let(:model) { described_class.new({}) }

      before { model.instance_variable_set(:@errors, ['error']) }

      it "returns true" do
        model.has_error?.should be_true
      end
    end

    context "when model hasn't error" do
      let(:model) { described_class.new({}) }

      it "returns false" do
        model.has_error?.should be_false
      end
    end
  end

  describe "#error" do
    let(:model) { described_class.new({}) }

    before { model.instance_variable_set(:@errors, ['Error1', 'Error2']) }
    it "returns error" do
      model.error.should == 'Error1. Error2'
    end
  end
end
