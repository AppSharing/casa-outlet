require 'pathname'
require 'casa/outlet/app/lti'

CASA::Outlet::App::Lti.set :static, true
CASA::Outlet::App::Lti.set :public_folder, Pathname.new(__FILE__).parent + 'www'
CASA::Outlet::App::Lti.set :views, Pathname.new(__FILE__).parent + 'views'

run CASA::Outlet::App::Lti