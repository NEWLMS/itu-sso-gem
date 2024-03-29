ENV["BUNDLE_GEMFILE"] = File.expand_path(File.dirname(__FILE__) + "/../../../Gemfile")
require "bundler"
Bundler.setup(:default, :development, :test)

require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "active_resource/railtie"
# require "rails/test_unit/railtie"

Bundler.require(:default, :development, :test)

module ITU
  module SSO
    class Application < Rails::Application
      config.root = File.dirname(__FILE__) + "/.."
      config.active_support.deprecation = :log
      config.eager_load = false
    end
  end
end

ITU::SSO::Application.initialize!
