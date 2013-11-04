class ORMProxy
  class ActiveRecord < ORMProxy

    def update_db
      record = model_klass.find_by_id(attributes['id'])
      if record
        attributes.delete('id')
        record.update_attributes(attributes, without_protection: true)
      else
        model_klass.create!(attributes, without_protection: true)
      end
    end

  end
end
