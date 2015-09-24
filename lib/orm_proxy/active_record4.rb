class ORMProxy
  class ActiveRecord4 < ORMProxy

    private

    def create_record(klass, attrs)
      klass.create!(attrs)
    end

    def update_record(record, attrs)
      record.update_attributes(attrs)
    end

  end
end
