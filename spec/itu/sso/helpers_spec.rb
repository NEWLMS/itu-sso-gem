require 'spec_helper'

describe ITU::SSO::Helpers do
  before do
    class DummyHelper < ActionView::Base; end

    ITU::SSO.configure do |config|
      config.url             = 'http://localhost:3000/api'
      config.access_token    = '81d891aa40ad853cbfad0e1dcdb17d64'
      config.user_auth_token = 'd06c34173b49111320a86cf4738dd264'
    end
  end

  subject { DummyHelper.new }

  describe '#current_user' do
    it 'returns an user', :type => :helper do
      VCR.use_cassette('get_user') do
        expect(subject.current_user).to be_instance_of(ITU::SSO::Resources::User)
        expect(subject.current_user.email).to eql('johndoe@itu-dev.edu')
      end
    end
  end
end
