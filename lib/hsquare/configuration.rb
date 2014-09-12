module Hsquare
  # Public: Configuration object for Hsquare.
  class Configuration
    # Public: Admin access key of Kakao application.
    attr_accessor :admin_key

    # Public: HTTP proxy URI.
    attr_accessor :http_proxy
  end
end
