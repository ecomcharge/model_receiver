require 'sinatra/base'
require 'rack/contrib/post_body_content_type_parser'

class ModelReceiver
  class App < Sinatra::Base
    use Rack::PostBodyContentTypeParser

    post '/' do
      model.modify

      response_for(model)
    end

    post '/destroy' do
      model.destroy

      response_for(model)
    end

    helpers do
      def model
        @model ||= begin
                     args = params
                     ModelReceiver.new(args)
                   end
      end

      def response_for(model)
        content_type :text

        if model.has_error?
          halt 422, model.error
        else
          "OK"
        end
      end
    end

  end
end
