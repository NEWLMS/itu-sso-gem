require 'spec_helper'

describe ITU::SSO::Configuration do
  before do
    ITU::SSO.configure do |config|
      config.url          = 'http://localhost:3000/api'
      config.access_token = '81d891aa40ad853cbfad0e1dcdb17d64'
      config.debug        = true
    end
  end

  it 'returns the url' do
    expect(ITU::SSO.configuration.url).to eql('http://localhost:3000/api')
  end

  it 'returns the access_token' do
    expect(ITU::SSO.configuration.access_token).to eql('81d891aa40ad853cbfad0e1dcdb17d64')
  end

  it 'returns the debug' do
    expect(ITU::SSO.configuration.debug).to eql(true)
  end
end
