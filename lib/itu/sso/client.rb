module ITU
  module SSO
    class Client
      attr_reader :access_token, :sso_url, :user, :connection

      def initialize
        @access_token = ITU::SSO.configuration.access_token
        @user_token   = ITU::SSO.configuration.user_auth_token
        @sso_url      = ITU::SSO.configuration.url
        @user         = User.new(@user_token, self)

        @connection = Faraday.new do |faraday|
          faraday.request :token_auth, access_token
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end

        self
      end

      def user_token=(t)
        @user.token = t
      end

      class User
        attr_accessor :token

        def initialize(token, client)
          @token  = token
          @client = client
        end

        def connection
          @client.connection
        end

        def get
          response = connection.get "#{@client.sso_url}/user",
                                     {},
                                     { 'Content-Type' => 'application/json',
                                       'X-UserAuthToken' => @token }

          user_data = @client.json(response.body)

          if response.status == 200
            Resources::User.new user_data
          else
            user_data
          end
        end

        def create(params)
          response = connection.post "#{@client.sso_url}/user",
                                      { user: params }.to_json,
                                      { 'Content-Type' => 'application/json' }

          user_data = @client.json(response.body)

          if response.status == 201
            self.token = user_data[:authentication_token]
            Resources::User.new user_data
          else
            user_data
          end
        end

        def update(params)
          response = connection.patch "#{@client.sso_url}/user",
                                       { user: params }.to_json,
                                       { 'Content-Type' => 'application/json',
                                         'X-UserAuthToken' => @token }

          user_data = @client.json(response.body)

          if response.status == 200
            self.token = user_data[:authentication_token]
            Resources::User.new user_data
          else
            user_data
          end
        end

        def delete
          response = connection.delete "#{@client.sso_url}/user",
                                       {},
                                       { 'Content-Type' => 'application/json',
                                         'X-UserAuthToken' => @token }

          response.status == 204
        end
      end

      def json(body)
        JSON.parse(body, symbolize_names: true)
      end
    end
  end
end
