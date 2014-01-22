require 'orm_proxy/active_record4'
require 'orm_proxy/active_record'
require 'active_support/core_ext/string/inflections'

class ORMProxy

  def self.build(model_name, attributes)
    if ::ActiveRecord::VERSION::MAJOR == 4
      ORMProxy::ActiveRecord4.new(model_name, attributes)
    else
      ORMProxy::ActiveRecord.new(model_name, attributes)
    end
  end

  attr_reader :model_name, :attributes
  def initialize(model_name, attributes)
    @model_name = model_name
    @attributes = prepare_attributes(attributes)
  end

  protected
  def model_klass
    model_name.classify.constantize
  end

  def prepare_attributes(attrs)
    if model_klass.respond_to?(:column_names)
      columns = model_klass.column_names
      attrs.select { |k,v| columns.include?(k) }
    else
      attrs
    end
  end

end
