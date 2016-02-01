module UdSync
  class OperationsController < UdSync::ApplicationController
    def index
      render body: false, status: 401 and return if forbidden?

      operations = UdSync::Operation
      if current_user_present?
        operations = operations.where(owner_id: current_user.id)
      end

      if params[:since].present?
        since = DateTime.parse(params[:since])
        operations = operations.where('created_at >= ?', since)
      end

      operations = operations.all

      render json: {
        operations: operations.map do |operation|
          {
            id:        operation.id.to_s,
            name:      operation.name,
            record_id: operation.external_id,
            entity:    operation.entity_name,
            date:      operation.created_at.iso8601,
          }
        end
      }
    end

    private

    def current_user_present?
      current_user.present?
    rescue NameError
      false
    end
  end
end
