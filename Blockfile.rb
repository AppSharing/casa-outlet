# Build Settings

set :build_path, 'www/blocks'

# Application Includes

include 'jquery'
include 'efx', 'driver'
include 'casa-outlet', 'engine', 'search', 'elasticsearch'

# Application Block Definition

block 'casa-outlet', :path => 'src' do |outlet|

  block 'config', :path => 'config' do
    block('engine'){ js_file 'engine.js' }
  end

  block 'engine', :path => 'engine' do |engine|

    block('core'){ js_file 'core.js' }

    block('route') do
      dependency engine.route 'core'
      dependency outlet.route 'config', 'engine'
      js_file 'route.js'
    end

    block 'search', :path => 'search' do

      block 'base' do
        js_file 'base.js'
        dependency engine.route 'core'
        dependency engine.route 'route'
      end

      block 'elasticsearch' do
        dependency engine.route 'search', 'base'
        js_file 'elasticsearch.js'
      end

    end

  end

end

# Existing Block Modifications

block 'efx' do

  dependency framework.route 'jquery'

end