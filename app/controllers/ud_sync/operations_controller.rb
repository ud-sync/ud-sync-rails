module UdSync
  class OperationsController < UdSync::ApplicationController
    def index
      render body: false, status: 401 and return if forbidden?

      operations = if current_user_present?
                     UdSync::Operation.where(owner_id: current_user.id).all
                   else
                     UdSync::Operation.all
                   end

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

    private

    def current_user_present?
      respond_to?(:current_user) && current_user.present?
    end
  end
end
