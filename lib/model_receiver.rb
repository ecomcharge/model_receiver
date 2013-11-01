require 'model_receiver/app'
require 'orm_proxy'
require 'active_support/core_ext/string/inflections'

class ModelReceiver

  attr_reader :params
  def initialize(params)
    @params = params
    @errors = []
  end

  def has_error?
    @errors.any?
  end

  def error
    @errors.join('. ')
  end

  def modify
    model = params.keys.first
    add_error("Can't recognize model name") && return unless model

    ORMProxy.build(model, params[model]).update_db
  end

  private
  def add_error(error)
    @errors << error
  end

end
