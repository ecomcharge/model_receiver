require 'model_receiver/app'
require 'orm_proxy'

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
    orm_proxy && orm_proxy.update_db
  end

  def destroy
    orm_proxy && orm_proxy.destroy
  end

  private
  def add_error(error)
    @errors << error
  end

  def orm_proxy
    @orm_proxy ||= begin
                     model = params.keys.first
                     add_error("Can't recognize model name") && return unless model

                     ORMProxy.build(model, params[model])
                   end
  end

end
