require 'spec_helper'

describe ITU::SSO::Client do
  describe "with valid client_id" do
    before do
      ITU::SSO.configure do |config|
        config.url = 'http://localhost:3300/api'
        config.client_secret = '81d891aa40ad853cbfad0e1dcdb17d64'
        config.client_id = '2c89e67d75a5eec2d473cafb2ab399b6'
      end
    end

    context 'attributes' do
      let(:client) { described_class.new }

      it 'has client_secret value' do
        expect(client.client_secret).to eql('81d891aa40ad853cbfad0e1dcdb17d64')
      end

      it 'has sso_url value' do
        expect(client.sso_url).to eql('http://localhost:3300/api')
      end
    end

    context 'actions' do
      describe '#create_user' do
        let(:client) { described_class.new }

        context 'succesfully' do
          it 'returns an User resourse' do
            VCR.use_cassette('valid_user_creation') do
              user = client.user.create(email: 'johndoe@itu-dev.edu',
                                        password: 'secret',
                                        password_confirmation: 'secret')
              expect(user).to be_instance_of(ITU::SSO::Resources::User)
            end
          end
        end

        context 'unsuccesfully' do
          it 'returns an hash with error messages' do
            VCR.use_cassette('invalid_user_creation') do
              user = client.user.create(email: 'johndoe@itu-dev.edu',
                                        password: 'secret',
                                        password_confirmation: 'secret')
              expect(user[:email]).to eql(['has already been taken'])
            end
          end
        end
      end

      describe '#get_user' do
        let(:client) { described_class.new('3115c713b64e5b2f034c8c9cd04573bf') }

        it 'returns user based on the auth token' do
          VCR.use_cassette('get_user') do
            user = client.user.get
            expect(user).to be_instance_of(ITU::SSO::Resources::User)
            expect(user.email).to eql('johndoe@itu-dev.edu')
          end
        end
      end


      describe '#update_user' do
        let(:client) { described_class.new('f0ec9a8f1135cf7b6980f695f13a58e9') }

        context 'succesfully' do
          it 'returns an User resourse' do
            VCR.use_cassette('valid_user_updating') do
              user = client.user.update(email: 'jondoe@itu-dev.edu')
              expect(user).to be_instance_of(ITU::SSO::Resources::User)
              expect(user.email).to eql('jondoe@itu-dev.edu')
            end
          end
        end

        context 'unsuccesfully' do
          it 'returns an hash with error messages' do
            VCR.use_cassette('invalid_user_updating') do
              user = client.user.update(email: nil)
              expect(user[:email]).to eql(["can't be blank", 'is invalid'])
            end
          end
        end
      end

      describe '#delete_user' do
        let(:client) { described_class.new('3115c713b64e5b2f034c8c9cd04573bf') }

        it 'returns true' do
          VCR.use_cassette('user_deleting') do
            result = client.user.delete
            expect(result).to eql(true)
          end
        end
      end
    end
  end

  describe "ITU::SSO::Client with invalid client_id" do
    before do
      ITU::SSO.configure do |config|
        config.url             = 'http://localhost:3300/api'
        config.client_secret   = '81d891aa40ad853cbfad0e1dcdb17d64'
        config.client_id   = '2c89e81d891aa40ad853cb67d75a5eec2d473cafb2ab399b6'
      end
    end

    context  '#wrong/invalid client_id' do
      let(:client) { described_class.new('f0ec9a8f1135cf7b6980f695f13a58e9') }


      it 'returns user based on the auth token' do
        VCR.use_cassette('get_user_with_invalid_client_id') do
          user = client.user.get
          expect(user[:error]).to eql("Invalid client id")
        end
      end
    end

  end
end
