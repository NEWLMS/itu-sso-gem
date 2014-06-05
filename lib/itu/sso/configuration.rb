module ITU
  module SSO
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure(&block)
      yield configuration
    end

    class Configuration
      attr_accessor :url, :access_token
    end
  end
end
