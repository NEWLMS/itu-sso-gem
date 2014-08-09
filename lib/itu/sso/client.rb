module ITU
  module SSO
    class Client
      attr_reader :client_secret, :sso_url, :user, :connection

      def initialize(user_auth_token=nil)
        @client_secret = ITU::SSO.configuration.client_secret
        @user_token   = user_auth_token
        @sso_url      = ITU::SSO.configuration.url
        @client_id    = ITU::SSO.configuration.client_id
        @user         = User.new(@user_token, self, @client_id)

        @connection = Faraday.new do |faraday|
          faraday.request :token_auth, client_secret
          faraday.adapter Faraday.default_adapter

          if ITU::SSO.configuration.debug
            faraday.response :logger
          end

        end

        self
      end

      def user_token=(t)
        @user.token = t
      end

      class User
        attr_accessor :token

        def initialize(token, client, client_id)
          raise ArgumentError, "Client ID can't be blank" if client_id.nil?
          @itu_id  = token
          @client = client
          @client_id = client_id
        end

        def connection
          @client.connection
        end

        def get
          response = connection.get "#{@client.sso_url}/users/",
                                     {id: @itu_id},
                                     { 'Content-Type' => 'application/json',
                                       'CLIENT-ID' =>  @client_id
                                     }

          user_data = @client.json(response.body)

          if response.status == 200
            Resources::User.new(user_data)
          else
            user_data
          end
        end

        def create(params)
          response = connection.post "#{@client.sso_url}/users",
                                      { user: params }.to_json,
                                      { 'Content-Type' => 'application/json',
                                        'CLIENT-ID' =>  @client_id
                                      }

          user_data = @client.json(response.body)

          if response.status == 201
            self.token = user_data[:access_token]
            Resources::User.new user_data
          else
            user_data
          end
        end

        def update(params)
          response = connection.patch "#{@client.sso_url}/users/",
                                       { user: params, id: @itu_id }.to_json,
                                       { 'Content-Type' => 'application/json',
                                         'CLIENT-ID' =>  @client_id}

          user_data = @client.json(response.body)

          if response.status == 200
            self.token = user_data[:access_token]
            Resources::User.new user_data
          else
            user_data
          end
        end

        def delete
          response = connection.delete "#{@client.sso_url}/users/",
                                       {id: @itu_id},
                                       { 'Content-Type' => 'application/json',
                                         'CLIENT-ID' =>  @client_id}

          response.status == 204
        end

        def authorize(params)
          response = connection.post "#{@client.sso_url}/authenticate",
                                      { user: params }.to_json,
                                      { 'Content-Type' => 'application/json' }

          user_data = @client.json(response.body)

          if response.status == 201
            self.token = user_data[:access_token]
            Resources::User.new user_data
          else
            user_data
          end

        end
      end

      def json(body)
        JSON.parse(body, symbolize_names: true)
      end
    end
  end
end
