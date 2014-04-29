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
      dependency framework.route 'bootstrap', 'type'
      dependency framework.route 'bootstrap', 'utilities'
      js_file 'core.js'
      scss_file 'core.scss'
    end

    block 'view', :path => 'view' do
      dependency framework.route 'bootstrap', 'buttons'
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

# Existing Block Modifications

block 'efx' do

  dependency framework.route 'jquery'

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

block 'bootstrap', :path => 'bower_components/bootstrap-sass/vendor/assets' do |bootstrap|

  block 'variables' do
    scss_file 'stylesheets/bootstrap/_variables.scss'
  end

  block 'base' do
    dependency bootstrap.route 'variables'
    scss_file 'stylesheets/bootstrap/_mixins.scss'
    scss_file 'stylesheets/bootstrap/_normalize.scss'
    scss_file 'stylesheets/bootstrap/_print.scss'
    scss_file 'stylesheets/bootstrap/_scaffolding.scss'
  end

  [
      'type',
      'code',
      'grid',
      'tables',
      'forms',
      'buttons',
      'component-animations',
      'glyphicons',
      'dropdowns',
      'button-groups',
      'input-groups',
      'navs',
      'navbar',
      'breadcrumbs',
      'pagination',
      'pager',
      'labels',
      'badges',
      'jumbotron',
      'thumbnails',
      'alerts',
      'progress-bars',
      'media',
      'list-group',
      'panels',
      'wells',
      'close',
      'utilities',
      'responsive-utilities'
  ].each do |name|
    block name do
      dependency bootstrap.route 'base'
      scss_file "stylesheets/bootstrap/_#{name}.scss"
    end
  end

  block 'navbar' do
    dependency bootstrap.route 'js', 'collapse'
    dependency bootstrap.route 'forms'
    dependency bootstrap.route 'navs'
  end

  block 'js' do |js|

    dependency bootstrap.route 'component-animations'

    block 'affix' do
      js_file 'javascripts/bootstrap/affix.js'
    end

    block 'alert' do
      js_file 'javascripts/bootstrap/alert.js'
    end

    block 'button' do
      bootstrap.route 'buttons'
      bootstrap.route 'button-groups'
      js_file 'javascripts/bootstrap/button.js'
    end

    block 'carousel' do
      js_file 'javascripts/bootstrap/carousel.js'
      scss_file 'stylesheets/bootstrap/_carousel.scss'
    end

    block 'collapse' do
      dependency js.route 'transition'
      js_file 'javascripts/bootstrap/collapse.js'
    end

    block 'dropdown' do
      js_file 'javascripts/bootstrap/dropdown.js'
    end

    block 'modal' do
      js_file 'javascripts/bootstrap/modal.js'
      scss_file 'stylesheets/bootstrap/_modals.scss'
    end

    block 'popover' do
      dependency js.route 'tooltip'
      js_file 'javascripts/bootstrap/popover.js'
      scss_file 'stylesheets/bootstrap/_popovers.scss'
    end

    block 'scrollspy' do
      js_file 'javascripts/bootstrap/scrollspy.js'
    end

    block 'tab' do
      js_file 'javascripts/bootstrap/tab.js'
    end

    block 'tooltip' do
      js_file 'javascripts/bootstrap/tooltip.js'
      scss_file 'stylesheets/bootstrap/_tooltip.scss'
    end

    block 'transition' do
      js_file 'javascripts/bootstrap/transition.js'
    end

  end

end