module UdSync
  class OperationsController < ActionController::Base
    def index
      operations = UdSync::Operation.all

      render json: {
        operations: operations.map do |operation|
          {
            id:        operation.id,
            name:      operation.name,
            record_id: operation.record_id,
            entity:    operation.entity_name,
            date:      operation.created_at.iso8601,
          }
        end
      }
    end
  end
end
