module ITU
  module SSO
    module Resources
      class User
        attr_reader :id, :email, :access_token

        def initialize(params)
          @id                   = params[:id]
          @email                = params[:email]
          @access_token = params[:access_token]
        end
      end
    end
  end
end
