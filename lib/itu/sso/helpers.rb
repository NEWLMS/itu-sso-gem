module ITU
  module SSO
    module Helpers
      def current_user
        unless @current_user
          if user_auth_token.present?
            client   = Client.new(cookies[:access_token_cookie])
            sso_user = client.user.get
              @current_user = User.find_by(itu_id: sso_user.id  )
          else
            @current_user = nil
          end
        end

        @current_user
      end

      def logout_user
        cookies[:user_auth_token] = { value: nil,
                                      domain: :all,
                                      httponly: true }
      end

      protected

      def user_auth_token
        if @user_auth_token.blank? and params[:token].present?
          key = ActiveSupport::KeyGenerator.new(ENV.fetch('SSO_SECRET_TOKEN')).generate_key(ENV.fetch('SSO_SECRET_SALT'))
          encryptor = ActiveSupport::MessageEncryptor.new(key)
          @user_auth_token = encryptor.decrypt_and_verify(params[:token])
        end

        @user_auth_token
      end
    end
  end
end
