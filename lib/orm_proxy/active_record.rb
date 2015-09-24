class ORMProxy
  class ActiveRecord < ORMProxy

    private

    def create_record(klass, attrs)
      klass.create!(attrs, without_protection: true)
    end

    def update_record(record, attrs)
      record.update_attributes(attrs, without_protection: true)
    end

  end
end
