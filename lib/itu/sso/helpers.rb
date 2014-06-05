module ITU
  module SSO
    module Helpers
      def current_user
        unless @current_user
          client = Client.new(user_auth_token)
          @current_user = client.user.get
        end

        @current_user
      end

      protected

      def user_auth_token
        unless @user_auth_token
          key = ActiveSupport::KeyGenerator.new(ENV.fetch('SSO_SECRET_TOKEN')).generate_key(ENV.fetch('SSO_SECRET_SALT'))
          encryptor = ActiveSupport::MessageEncryptor.new(key)
          @user_auth_token = encryptor.decrypt_and_verify(cookies[:user_auth_token])
        end

        @user_auth_token
      end
    end
  end
end
