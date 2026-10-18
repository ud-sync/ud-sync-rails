module UdSync
  module ModelExtension
    extend ActiveSupport::Concern

    # Options passed to `ud_sync`, keyed by model class name.
    def self.options
      @options ||= {}
    end

    class_methods do
      def ud_sync(entity: nil, id: :id, owner: nil)
        UdSync::ModelExtension.options[self.name] = {
          entity: entity,
          id: id,
          owner: owner
        }

        self.after_save :save_operation
        self.after_destroy :save_operation
      end
    end

    def save_operation
      UdSync::Sentinel.new(self, UdSync::ModelExtension.options[self.class.name]).save_operation
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include UdSync::ModelExtension
end
