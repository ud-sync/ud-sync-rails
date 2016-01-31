module UdSync
  class OperationsController < ActionController::Base
    def index
      operations = UdSync::Operation.all

      render json: {
        operations: operations.map do |operation|
          {
            name: operation.name
          }
        end
      }
    end
  end
end
