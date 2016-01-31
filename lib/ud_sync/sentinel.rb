module UdSync
  class Sentinel

    def initialize(model, options)
      @model = model
      @options = options
    end

    def save_operation
      operation = if model.destroyed?
                    :delete
                  else
                    :save
                  end

      UdSync::Operation.create(
        name:        operation,
        record_id:   model.id,
        external_id: external_id,
        owner_id:    owner_id,
        entity_name: operation_name
      )
    end

    private

    attr_accessor :model, :options

    def external_id
      attribute = options[:id]
      model.public_send(attribute)
    end

    def owner_id
      if options[:owner].present?
        attribute = "#{options[:owner]}".to_sym

        if model.respond_to?(attribute) && model.public_send(attribute).present?
          association = model.public_send(attribute)
          if association.respond_to?(:id)
            association.id.to_s
          else
            raise OwnerAssociationHasNoIdError, "The owner association has no id column"
          end
        end
      end
    end

    def operation_name
      options[:entity] || model.class.name
    end
  end
end
