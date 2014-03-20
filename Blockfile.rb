# Build Settings

set :build_path, 'www/blocks'

# Application Includes

include 'jquery'
include 'efx', 'driver'
include 'casa-outlet', 'app', 'controller'
include 'casa-outlet', 'engine', 'search', 'driver', 'elasticsearch'
include 'casa-outlet', 'engine', 'search', 'driver', 'query'

# Application Block Definition

block 'casa-outlet', :path => 'src' do |outlet|

  block 'app', :path => 'app' do |app|

    block('core'){ js_file 'core.js' }

    block 'controller', :path => 'controller' do |controller|
      dependency app.route 'core'
      dependency framework.route 'ejs_production'
      js_file 'landing.js'
      js_file 'query.js'
      js_file 'search_collection.js'
    end

  end

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

      dependency engine.route 'core'
      dependency engine.route 'route'

      block('base'){ js_file 'base.js' }

      block 'driver' do

        dependency engine.route 'search', 'base'

        block('elasticsearch'){ js_file 'elasticsearch.js' }
        block('query'){ js_file 'query.js' }

      end

    end

  end

end

# Additional Block Definitions

block 'ejs_production', :path => 'bower_components/ejs_production' do

  js_file 'ejs.js'

end

# Existing Block Modifications

block 'efx' do

  dependency framework.route 'jquery'

end