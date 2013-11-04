class ORMProxy
  class ActiveRecord4 < ORMProxy

    def update_db
      record = model_klass.find_by_id(attributes['id'])
      if record
        attributes.delete('id')
        record.update_attributes(attributes)
      else
        model_klass.create!(attributes)
      end
    end

  end
end
