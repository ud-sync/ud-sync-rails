module ActiveRecord
  class Base
    class << self
      def ud_sync(entity: nil, id: :id, owner: nil)
        @@ud_sync_options ||= {}

        class_name = self.name
        @@ud_sync_options[class_name] = {
          entity: entity,
          id: id,
          owner: owner
        }

        self.after_save :save_operation
        self.after_destroy :save_operation
      end
    end

    def save_operation
      UdSync::Sentinel.new(self, @@ud_sync_options[self.class.name]).save_operation
    end
  end
end
