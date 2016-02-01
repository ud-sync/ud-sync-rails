module UdSync
  class ApplicationController < ::ApplicationController

    private

    def forbidden?
      current_user.blank?
    rescue NameError
      false
    end
  end
end
