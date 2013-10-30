require 'model_receiver/app'
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

    update_db(model, params[model])
  end

  private
  def add_error(error)
    @errors << error
  end

  def update_db(model, attrs)
    klass = model.classify.constantize

    record = klass.find_by_id(attrs['id'])
    if record
      attrs.delete('id')
      record.update_attributes(attrs, without_protection: true)
    else
      klass.create!(attrs, without_protection: true)
    end
  end

end
