module UdSync
  class Operation < ActiveRecord::Base
    self.table_name = :ud_sync_operations
  end
end
