require 'spec_helper'

describe ITU::SSO::Helpers do
  before do
    class DummyHelper < ActionView::Base
      def cookies
        @cookies ||= {}
      end

      protected

      def user_auth_token
        'd06c34173b49111320a86cf4738dd264'
      end
    end

    ITU::SSO.configure do |config|
      config.url          = 'http://localhost:3000/api'
      config.client_secret = '81d891aa40ad853cbfad0e1dcdb17d64'
    end

    User.create(email: 'johndoe@itu-dev.edu',
                access_token: 'd06c34173b49111320a86cf4738dd264')
  end

  subject { DummyHelper.new }

  describe '#current_user' do
    it 'returns an user' do
      VCR.use_cassette('get_user') do
        expect(subject.current_user).to be_instance_of(::User)
        expect(subject.current_user.email).to eql('johndoe@itu-dev.edu')
      end
    end
  end

  describe '#logout_user' do
    it 'clears user_auth_token cookie' do
      subject.cookies[:user_auth_token] = { value: '123' }
      subject.logout_user

      expect(subject.cookies[:user_auth_token][:value]).to be_nil
    end
  end
end
