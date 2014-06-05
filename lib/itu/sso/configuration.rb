module ITU
  module SSO
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure(&block)
      yield configuration
    end

    class Configuration
      attr_accessor :url, :access_token, :debug

      def initialize
        @debug = false
      end
    end
  end
end
