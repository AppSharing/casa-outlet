# Build Settings

set :build_path, 'www/blocks'

# Application Includes

include 'jquery'
include 'efx', 'driver'
include 'casa-outlet', 'config', 'app'
include 'casa-outlet', 'config', 'engine'
include 'casa-outlet', 'app', 'controller'
include 'casa-outlet', 'app', 'view'
include 'casa-outlet', 'engine', 'search', 'driver', 'elasticsearch'
include 'casa-outlet', 'engine', 'search', 'driver', 'query'

# Application Block Definition

block 'casa-outlet', :path => 'src' do |outlet|

  block 'util' do

    js_file 'util.js'
    dependency framework.route 'normalize-css'

  end

  block 'app', :path => 'app' do |app|

    dependency outlet.route 'util'
    dependency framework.route 'ejs_production'
    dependency framework.route 'phpjs', 'strings', 'strip_tags'

    block 'core' do
      js_file 'core.js'
      scss_file 'core.scss'
    end

    block 'view', :path => 'view' do
      dependency app.route 'core'
      scss_file 'common.scss'
      scss_file 'app-row.scss'
      scss_file 'app-list.scss'
      scss_file 'app-details.scss'
    end

    block 'controller', :path => 'controller' do
      dependency app.route 'core'
      js_file 'details.js'
      js_file 'landing.js'
      js_file 'query.js'
      js_file 'search_collection.js'
    end

  end

  block 'config', :path => 'config' do

    block('app') do
      dependency outlet.route 'app', 'core'
      js_file 'app.js'
    end

    block 'engine' do
      dependency outlet.route 'engine', 'core'
      js_file 'engine.js'
    end
  end

  block 'engine', :path => 'engine' do |engine|

    dependency outlet.route 'util'

    block('core') { js_file 'core.js' }

    block 'route' do

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

block 'normalize-css', :path => 'bower_components/normalize-css' do

  scss_file 'normalize.css'

end

block 'phpjs', :path => 'bower_components/phpjs/functions' do |phpjs|

  functions_path = phpjs.resolved_path
  Dir.foreach functions_path do |directory_name|
    next if directory_name == '.' or directory_name == '..'
    block directory_name, :path => directory_name do
      Dir.foreach functions_path + directory_name do |file_name|
        next if file_name == '.' or file_name == '..' or !file_name.match /\.js$/
        block(file_name.gsub(/\.js$/, '')){ js_file file_name }
      end
    end
  end

end

# Existing Block Modifications

block 'efx' do

  dependency framework.route 'jquery'

end