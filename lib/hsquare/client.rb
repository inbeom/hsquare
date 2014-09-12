module Hsquare
  # Public: HTTP(S) client for Kakao API.
  class Client
    include HTTParty

    # Public: HTTP(S) client for Kakao API with Admin access.
    class Admin < Client
      base_uri 'https://kapi.kakao.com'

      # Public: Getter for admin_key.
      #
      # Returns String of admin key.
      def self.admin_key
        @admin_key
      end

      # Public: Setter for admin_key.
      #
      # admin_key - Admin key to newly set.
      #
      # Returns nothing.
      def self.admin_key=(admin_key)
        @admin_key = admin_key

        default_options.merge!(headers: { 'Authorization' => "KakaoAK #{admin_key}" })
      end
    end
  end
end
