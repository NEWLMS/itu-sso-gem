module ITU
  module SSO
    module Resources
      class User
        attr_reader :id, :email, :authentication_token

        def initialize(params)
          @id                   = params[:id]
          @email                = params[:email]
          @authentication_token = params[:authentication_token]
        end
      end
    end
  end
end
