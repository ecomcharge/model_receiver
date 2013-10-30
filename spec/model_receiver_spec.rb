require 'spec_helper'

describe ModelReceiver do

  describe "#modify" do
    let(:params) { { 'shops' => attributes } }
    let(:model)  { described_class.new(params) }
    let(:attributes) { {'id' => 1, 'name' => 'test'} }
    let(:attrs_for_update) { {'name' => 'test'} }

    context "when model class exists" do
      class Shop; end

      context "when record doesn't exist" do
        it "adds new record" do
          Shop.should_receive(:find_by_id).with(1).and_return(nil)
          Shop.should_receive(:create!).with(attributes, without_protection: true)

          model.modify
        end
      end

      context "when record already exists" do
        let(:record) { double('record') }
        it "updates record" do
          Shop.should_receive(:find_by_id).with(1).and_return(record)
          record.should_receive(:update_attributes).with(attrs_for_update, without_protection: true)

          model.modify
        end
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
