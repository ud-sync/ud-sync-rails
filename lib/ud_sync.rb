require "ud_sync/version"

require "ud_sync/engine"
require "ud_sync/sentinel"
require "ud_sync/rails/model_extension"

module UdSync
  class OwnerAssociationHasNoIdError < StandardError; end
end
