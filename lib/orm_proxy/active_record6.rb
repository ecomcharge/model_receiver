class ORMProxy
  class ActiveRecord6 < ORMProxy

    private
    
    def create_record(klass, attrs)
      klass.create!(attrs)
    end

    def update_record(record, attrs)
      record.update(attrs)
    end
  end
end
