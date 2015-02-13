require 'cortex/client/oauth'
require 'cortex/client/apis/api_base'
require 'cortex/client/apis/v1'
require 'cortex/client/config'
require 'cortex/client/response'
require 'cortex/client/resources/resource_base'
require 'cortex/client/resources/posts'
require 'cortex/client/resources/media'

module Cortex
  module Client
    class Client
      attr_reader :posts, :media

      def initialize(options = {})
        @options = options
        @posts = Resources::Posts.new(apis, options)
        @media = Resources::Media.new(apis, options)
      end

      private

      def apis
        { v1: APIs::V1.new(@options) }
      end
    end
  end
end