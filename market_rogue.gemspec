Gem::Specification.new do |s|
  s.name               = 'market_rogue'
  s.version            = '0.0.1'

  s.authors = ['André Herculano']
  s.date = '2016-06-22'
  s.description = 'A market scrapper for Ragnarok'
  s.summary = 'A market scrapper for Ragnarok.'
  s.email = 'andresilveirah@gmail.com'
  s.homepage = 'http://codebikeandmore.com'
  s.license = 'MIT'

  s.files = ['Rakefile',
             'lib/market_rogue.rb',
             'lib/authenticator.rb',
             'lib/querier.rb',
             'lib/results_parser.rb' ]
  s.test_files = ['spec/market_rogue_spec.rb']
  s.require_path = 'lib'

  s.add_runtime_dependency 'mechanize'        ,'~> 2.7'
  s.add_development_dependency 'rake'         ,'~> 11'
  s.add_development_dependency 'bundler'      ,'~> 1'
  s.add_development_dependency 'minitest'     ,'~> 5'
  s.add_development_dependency 'vcr'          ,'~> 2.9'
  s.add_development_dependency 'minitest-vcr' ,'~> 1.4'
  s.add_development_dependency 'webmock'      ,'~> 2'
end
