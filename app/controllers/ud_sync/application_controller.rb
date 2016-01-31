module UdSync
  class ApplicationController < ::ApplicationController

    private

    def forbidden?
      respond_to?(:current_user) && current_user.blank?
    end
  end
end
