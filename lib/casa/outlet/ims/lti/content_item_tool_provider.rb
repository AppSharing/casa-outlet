require 'json'
require 'ims/lti'
require 'casa/outlet/ims/lti/content_item_launch_params'

module CASA
  module Outlet
    module IMS
      module LTI
        class ContentItemToolProvider < ::IMS::LTI::ToolProvider

          include ContentItemLaunchParams

          attr_accessor :content_item_requests

          def initialize(consumer_key, consumer_secret, params={})
            super(consumer_key, consumer_secret, params)
            @content_item_requests = []
          end

          def content_item_selection_request?
            lti_message_type == 'ContentItemSelectionRequest'
          end

          def to_params
            content_item_launch_data_hash.merge super
          end

          def process_params(params)
            super(params)
            params.each_pair do |key, val|
              if CONTENT_ITEM_LAUNCH_DATA_PARAMETERS.member?(key)
                self.send("#{key}=".to_sym, val)
              end
            end
          end

          def has_required_attributes?
            @consumer_key && @consumer_secret && @content_item_return_url
          end

        end
      end
    end
  end
end