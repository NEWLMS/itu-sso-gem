require 'rails/railtie'

module ITU
  module SSO
    class Railtie < Rails::Railtie
      generators do
      end

      rake_tasks do
      end

      initializer 'itu.sso.initialize' do
        ::ActionController::Base.instance_eval do
          helper ITU::SSO::Helpers
        end

        ActionView::Base.send :include, ITU::SSO::Helpers
      end
    end
  end
end
