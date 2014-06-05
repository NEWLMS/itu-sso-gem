require 'spec_helper'

describe ITU::SSO::Client do
  context 'attributes' do
    let(:client) { described_class.new({ token: '12345',
                                         user_token: '54321',
                                         url: 'http://localhost:3000/api' }) }

    it 'has access_token value' do
      expect(client.access_token).to eql('12345')
    end

    it 'has sso_url value' do
      expect(client.sso_url).to eql('http://localhost:3000/api')
    end
  end

  context 'actions' do
    let(:client) { described_class.new({ token: '81d891aa40ad853cbfad0e1dcdb17d64',
                                         url: 'http://localhost:3000/api' }) }

    describe '#create_user' do
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
      it 'returns user based on the auth token' do
        client.user_token = 'b4b17cdcde6684750d6b883eabb1a320'

        VCR.use_cassette('get_user') do
          user = client.user.get
          expect(user).to be_instance_of(ITU::SSO::Resources::User)
          expect(user.email).to eql('johndoe@itu-dev.edu')
        end
      end
    end

    describe '#update_user' do
      before do
        client.user_token = 'b4b17cdcde6684750d6b883eabb1a320'
      end

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
      before do
        client.user_token = 'b4b17cdcde6684750d6b883eabb1a320'
      end

      it 'returns true' do
        VCR.use_cassette('user_deleting') do
          result = client.user.delete
          expect(result).to eql(true)
        end
      end
    end
  end
end
