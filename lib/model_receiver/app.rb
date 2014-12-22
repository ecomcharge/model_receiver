require 'sinatra/base'
require 'rack/contrib/post_body_content_type_parser'

class ModelReceiver
  class App < Sinatra::Base
    use Rack::PostBodyContentTypeParser unless defined?(Rails)

    post '/' do
      headers('Content-Type' => 'text/plain')

      args = params
      unless args.is_a?(Hash)
        args = env['action_dispatch.request.request_parameters'] || env['rack.request.form_hash']
      end

      model = ModelReceiver.new(args)
      model.modify

      if model.has_error?
        halt 422, model.error
      else
        "OK"
      end
    end

  end
end
