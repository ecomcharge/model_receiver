require 'spec_helper'

describe ModelReceiver::App do
  def app
    ModelReceiver::App
  end

  describe "POST request to /" do
    let(:headers)    { {'CONTENT_TYPE' => 'application/json'}  }
    let(:content)    { '{"models":{"id":1,"name":"test"}}' }
    let(:attributes) { { 'models' => { 'id' => 1, 'name' => 'test' } } }
    let(:response) do
        post "/", content, headers
        last_response
      end

    it "modifies model data according with passed attributes" do
      ModelReceiver.should_receive(:new).with(attributes)
        .and_return(double(has_error?: false, modify: true))

      post "/", content, headers
    end

    context "when model has error" do
      let(:model) { double('model', has_error?: true, error: 'error', modify: true) }

      before { ModelReceiver.should_receive(:new).with(attributes).and_return(model) }

      it "returns 422 status" do
        response.status.should == 422
      end

      it "returns error message" do
        response.body.should == 'error'
      end
    end

    context "when model hasn't error" do
      let(:model) { double('model', has_error?: false, modify: true) }

      before { ModelReceiver.should_receive(:new).with(attributes).and_return(model) }

      it "returns 200 status" do
        response.status.should == 200
      end

      it "returns OK text" do
        response.body.should == 'OK'
      end

      it "returns Content-Type='text/plain' " do
        response.headers.should include('Content-Type' => 'text/plain')
      end
    end
  end

end
