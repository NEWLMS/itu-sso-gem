module ITU
  module SSO
    module Helpers
      def current_user
        unless @current_user
          client = Client.new
          @current_user = client.user.get
        end

        @current_user
      end
    end
  end
end
