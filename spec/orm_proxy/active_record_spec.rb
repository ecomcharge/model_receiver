require 'spec_helper'

describe ORMProxy::ActiveRecord do

  describe "#update_db" do
    let(:model)  { 'shops' }
    let(:attributes) { {'id' => 1, 'name' => 'test'} }
    let(:attrs_for_update) { {'name' => 'test'} }

    let(:proxy) { described_class.new(model, attributes) }

    context "when model class exists" do
      class Shop; end

      context "when record doesn't exist" do
        it "adds new record" do
          expect(Shop).to receive(:find_by_id).with(1).and_return(nil)
          expect(Shop).to receive(:create!).with(attributes, without_protection: true)

          proxy.update_db
        end
      end

      context "when record already exists" do
        let(:record) { double('record') }

        it "updates record" do
          expect(Shop).to receive(:find_by_id).with(1).and_return(record)
          expect(record).to receive(:update_attributes).with(attrs_for_update, without_protection: true)

          proxy.update_db
        end
      end

      context "when habtms is present" do
        class BrandsShop; end

        let(:record) { double('record', id: 1) }
        let(:attributes) { {'id' => 1, 'name' => 'test', '_adds' => {'habtms' => {'brands' => ['1', '2']}}} }

        before do
          expect(Shop).to receive(:find_by_id).with(1).and_return(record)
          expect(record).to receive(:update_attributes).with(attrs_for_update, without_protection: true)
        end

        it "deletes all habmts previous values and inserts new passed values" do
          expect(BrandsShop).to receive(:delete_all).with(["shop_id = ?", 1])
          expect(BrandsShop).to receive(:create!).with({'shop_id' => 1, 'brand_id' => '1'}, without_protection: true)
          expect(BrandsShop).to receive(:create!).with({'shop_id' => 1, 'brand_id' => '2'}, without_protection: true)

          proxy.update_db
        end
      end
    end

  end

  describe "#destroy" do
    let(:model)  { 'shops' }
    let(:attributes) { {'id' => 1, 'name' => 'test'} }
    let(:attrs_for_update) { {'name' => 'test'} }
    let(:record) { double('record') }
    let(:records) { [record] }

    let(:proxy) { described_class.new(model, attributes) }

    context "when model class exists" do
      class Shop; end

      context "when primary key is present" do
        it "destroys by primary key" do
          expect(Shop).to receive(:primary_key).and_return('id')
          expect(Shop).to receive(:where).with('id' => 1).and_return(records)
          expect(record).to receive(:destroy!)

          proxy.destroy
        end
      end

      context "when primary key isn't present" do
        it "destroys by attributes" do
          expect(Shop).to receive(:primary_key).and_return(nil)
          expect(Shop).to receive(:where).with(attributes).and_return(records)
          expect(record).to receive(:destroy!)

          proxy.destroy
        end
      end
    end

  end

end
