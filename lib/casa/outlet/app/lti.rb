require 'securerandom'
require 'open-uri'
require 'sinatra/base'
require 'casa/outlet/ims/lti/content_item_tool_provider'
require 'oauth'
require 'oauth/request_proxy/rack_request'

module CASA
  module Outlet
    module App
      class Lti < Sinatra::Base

        configure do

          enable :sessions
          set :protection, :except => :frame_options
          set :oauth_creds, {
            "test" => "secret"
          }

        end

        post '/lti/launch' do

          return erb :error unless authorize!

          signature = OAuth::Signature.build(request, :consumer_secret => @tp.consumer_secret)
          @signature_base_string = signature.signature_base_string
          @secret = signature.send(:secret)

          @tp.lti_msg = "Sorry that tool was so boring"
          erb :success

        end

        get '/lti/consumer' do
          if session['launch_params']
            key = session['launch_params']['oauth_consumer_key']
          else
            show_error "The tool never launched"
            return erb :error
          end
        end

        post '/lti/consumer' do

          if session['launch_params']
            key = session['launch_params']['oauth_consumer_key']
          else
            show_error "The tool never launched"
            return erb :error
          end

          @tp = CASA::Outlet::IMS::LTI::ContentItemToolProvider.new(key, settings.oauth_creds[key], session['launch_params'])

          app = JSON.parse params[:app]
          attributes = app['attributes']['use'].merge app['attributes']['require'].merge app['attributes']

          content_item = {
            '@type' => 'ContentItem',
            '@id' => attributes['uri'],
            'mediaType' => 'text/html',
            'title' => attributes.has_key?('title') ? attributes['title'] : 'Untitled'
          }

          content_item['text'] = attributes['description'] if attributes.has_key?('description')

          # TODO: these attributes do not exist yet:
          #content_item['icon'] = {'@id'=>attributes['icon']} if attributes.has_key?('icon')
          #content_item['thumbnail'] = {'@id'=>attributes['icon']} if attributes.has_key?('thumbnail')

          @parameters = generate_parameters(content_item)

          consumer = OAuth::Consumer.new(@tp.consumer_key, @tp.consumer_secret)
          token = OAuth::AccessToken.new(consumer)

          req = OAuth::RequestProxy.proxy({
            'parameters'=>@parameters,
            'method'=>'POST',
            'uri'=>@tp.content_item_return_url
          })

          @parameters['oauth_signature'] = req.sign({
            :consumer => consumer,
            :signature_method => @tp.oauth_signature_method
          })

          @parameters['content_items'] = @parameters['content_items'].gsub('"','&quot;').gsub("'", "&#39;")

          return erb :return_to_consumer

        end

        def generate_parameters(content_item)

          params = {
            'content_items' => generate_content_items(content_item).to_json,
            'oauth_version' => @tp.oauth_version,
            'oauth_nonce' => SecureRandom.hex,
            'oauth_timestamp' => Time.now.to_i,
            'oauth_consumer_key' => @tp.oauth_consumer_key,
            'oauth_callback' => @tp.oauth_callback,
            'oauth_signature_method' => @tp.oauth_signature_method
          }

          params['data'] = @tp.data if @tp.data

          params

        end

        def generate_content_items(content_item)
          {
            '@context' => 'http://purl.imsglobal.org/ctx/lti/v1/ContentItemPlacement',
            '@graph' => [
              '@type' => 'ContentItemPlacement',
              'presentation_document_target' => 'window',
              'placementOf' => content_item
            ]
          }
        end

        def authorize!
          if key = params['oauth_consumer_key']
            if secret = settings.oauth_creds[key]
              @tp = CASA::Outlet::IMS::LTI::ContentItemToolProvider.new(key, secret, params)
            else
              @tp = CASA::Outlet::IMS::LTI::ContentItemToolProvider.new(nil, nil, params)
              @tp.lti_msg = "Your consumer didn't use a recognized key."
              @tp.lti_errorlog = "You did it wrong!"
              show_error "Consumer key wasn't recognized"
              return false
            end
          else
            show_error "No consumer key"
            return false
          end

          if !@tp.valid_request?(request)
            show_error "The OAuth signature was invalid"
            return false
          end

          if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
            show_error "Your request is too old."
            return false
          end

          # this isn't actually checking anything like it should, just want people
          # implementing real tools to be aware they need to check the nonce
          if was_nonce_used_in_last_x_minutes?(@tp.request_oauth_nonce, 60)
            show_error "Why are you reusing the nonce?"
            return false
          end

          # save the launch parameters for use in later request
          session['launch_params'] = @tp.to_params

          @username = @tp.username("Dude")

          return true
        end

        def show_error(message)
          @message = message
        end

        def was_nonce_used_in_last_x_minutes?(nonce, minutes=60)
          # some kind of caching solution or something to keep a short-term memory of used nonces
          false
        end

      end
    end
  end
end