require "spec_helper"

describe ITU::SSO::Resources::User do
  context 'attributes' do
    let(:user) { described_class.new({ id: 1,
                                       email: 'johndoe@itu-dev.edu',
                                       authentication_token: '12345' }) }

    it 'has id value' do
      expect(user.id).to eql(1)
    end

    it 'has email value' do
      expect(user.email).to eql('johndoe@itu-dev.edu')
    end

    it 'has authentication_token value' do
      expect(user.authentication_token).to eql('12345')
    end
  end
end
