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

  attr_reader :model_name, :attributes, :habtms
  def initialize(model_name, attributes)
    @model_name = model_name
    @attributes = prepare_attributes(attributes)
    @habtms = prepare_habtms(attributes)
  end

  def update_db
    record = model_klass.find_by_id(attributes['id'])
    if record
      attributes.delete('id')
      update_record(record, attributes)
    else
      create_record(model_klass, attributes)
    end

    update_habtm_values(record) if habtms
  end

  def destroy
    primary_key = model_klass.primary_key
    search_attributes = attributes

    if primary_key && attributes[primary_key]
      search_attributes = {primary_key => attributes[primary_key]}
    end

    record = model_klass.where(search_attributes).first
    record.destroy! if record
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

  def prepare_habtms(attrs)
    attrs['_adds']['habtms'] if attrs['_adds']
  end

  private

  def model_key
    model_name.singularize.foreign_key
  end

  def habtm_key(habtm)
    habtm.singularize.foreign_key
  end

  def update_habtm_values(record)
    record ||= model_klass.find_by_id(attributes['id'])

    habtms.each do |habtm, values|
      habtm_model = [model_name, habtm].sort.join("_")
      habtm_class = habtm_model.singularize.classify.constantize

      habtm_class.delete_all(["#{model_key} = ?", record.id])
      habtm_key = habtm_key(habtm)

      values.each do |value|
        create_record(habtm_class, {model_key => record.id, habtm_key => value})
      end
    end
  end

end
