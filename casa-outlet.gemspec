# coding: utf-8

Gem::Specification.new do |s|

  s.name        = 'casa-outlet'
  s.version     = '0.0.01'
  s.summary     = 'Reference implementation of the CASA Outlet'
  s.authors     = ['Eric Bollens']
  s.email       = ['ebollens@ucla.edu']
  s.homepage    = 'http://appsharing.github.io'
  s.license     = 'BSD-3-Clause'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'sinatra'
  s.add_dependency 'ims-lti'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'web_blocks'

end