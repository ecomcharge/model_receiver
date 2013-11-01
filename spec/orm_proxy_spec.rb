require 'spec_helper'

module ActiveRecord
  module VERSION
    MAJOR = 3
  end
end

describe ORMProxy do

  describe ".build" do
    let(:model) { 'model' }
    let(:attributes) { {} }

    context "when active_record version more than 4" do
       before do
        ActiveRecord::VERSION.send(:remove_const, 'MAJOR')
        ActiveRecord::VERSION.const_set('MAJOR', 4)
      end

      it "initializes ORMProxy::ActiveRecord4" do
        ORMProxy::ActiveRecord4.should_receive(:new).with(model, attributes)

        ORMProxy.build(model, attributes)
      end
    end

    context "when active_record version less than 4" do
      before do
        ActiveRecord::VERSION.send(:remove_const, 'MAJOR')
        ActiveRecord::VERSION.const_set('MAJOR', 3)
      end

      it "initializes ORMProxy::ActiveRecord" do
        ORMProxy::ActiveRecord.should_receive(:new).with(model, attributes)

        ORMProxy.build(model, attributes)
      end
    end
  end

end
