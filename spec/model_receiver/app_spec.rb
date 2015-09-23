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
      expect(ModelReceiver).to receive(:new).with(attributes)
        .and_return(double(has_error?: false, modify: true))

      post "/", content, headers
    end

    context "when model has error" do
      let(:model) { double('model', has_error?: true, error: 'error', modify: true) }

      before { expect(ModelReceiver).to receive(:new).with(attributes).and_return(model) }

      it "returns 422 status" do
        expect(response.status).to eq(422)
      end

      it "returns error message" do
        expect(response.body).to eq('error')
      end
    end

    context "when model hasn't error" do
      let(:model) { double('model', has_error?: false, modify: true) }

      before { expect(ModelReceiver).to receive(:new).with(attributes).and_return(model) }

      it "returns 200 status" do
        expect(response.status).to eq(200)
      end

      it "returns OK text" do
        expect(response.body).to eq('OK')
      end

      it "returns Content-Type='text/plain' " do
        expect(response.headers).to include('Content-Type' => 'text/plain;charset=utf-8')
      end
    end
  end

  describe "POST request to /desctroy" do
    let(:headers)    { {'CONTENT_TYPE' => 'application/json'}  }
    let(:content)    { '{"models":{"id":1,"name":"test"}}' }
    let(:attributes) { { 'models' => { 'id' => 1, 'name' => 'test' } } }
    let(:response) do
        post "/destroy", content, headers
        last_response
      end

    it "destroys model with passed attributes" do
      expect(ModelReceiver).to receive(:new).with(attributes)
        .and_return(double(has_error?: false, destroy: true))

      post "/destroy", content, headers
    end

    context "when model has error" do
      let(:model) { double('model', has_error?: true, error: 'error', destroy: true) }

      before { expect(ModelReceiver).to receive(:new).with(attributes).and_return(model) }

      it "returns 422 status" do
        expect(response.status).to eq(422)
      end

      it "returns error message" do
        expect(response.body).to eq('error')
      end
    end

    context "when model hasn't error" do
      let(:model) { double('model', has_error?: false, destroy: true) }

      before { expect(ModelReceiver).to receive(:new).with(attributes).and_return(model) }

      it "returns 200 status" do
        expect(response.status).to eq(200)
      end

      it "returns OK text" do
        expect(response.body).to eq('OK')
      end

      it "returns Content-Type='text/plain' " do
        expect(response.headers).to include('Content-Type' => 'text/plain;charset=utf-8')
      end
    end
  end

end
