source 'http://rubygems.org'
gem 'rails', '2.3.16'
gem 'rack'
gem 'rake'
gem 'mysql'

gem 'activemerchant', :require => 'active_merchant'
gem 'awesome_nested_set'
gem 'aws-s3', :require => 'aws/s3'
gem 'calendar_date_select'
gem 'chronic'
gem 'color-tools', :require => 'color'
gem 'completeness-fu', '0.5.2'
gem 'daemons', '1.0.10'
gem 'fastercsv'
gem 'feed-normalizer'
gem 'formtastic', '< 2'
gem 'flickraw'
gem 'hpricot'
gem 'mail', :require => false
gem 'nokogiri'
gem 'omniauth', '~> 0.3.0'
gem 'packet'
gem 'paperclip'
gem 'pdf-writer', :require => 'pdf/writer'
gem 'pony', :require => false
gem 'rack-rewrite', :require => 'rack/rewrite'
gem 'RedCloth', :require => 'redcloth'
# gem 'rmagick', '~> 2.13.2'
gem 'recaptcha', :require => "recaptcha/rails"
gem 'simple-rss'
gem 'searchlogic'#, '2.4.14'
gem 'thinking-sphinx', '1.4.10', :require => 'thinking_sphinx'
gem 'transaction-simple', :require => 'transaction/simple'
gem 'validation_reflection', '< 1'
gem 'whenever', '~>0.7.0', :require => false
gem 'will_paginate', :require => 'will_paginate'
gem 'xml-simple'
gem 'youtube-g', :require => 'youtube_g'
gem 'geokit'

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  # gem 'rvm-capistrano'
end

group :test, :cucumber do
  gem 'cucumber-rails', '>=0.3.2', :require => false
  gem 'rspec-rails', '< 2.0', :require => 'spec/rails'

  gem 'capybara', '< 0.4', :require => false # capybara 0.4 and cucumber-rails 0.3.2 have a bug (monkey-patching FTL)
  gem 'database_cleaner', '>=0.5.2', :require => false
  gem 'email_spec', '< 1.0', :require => false
  gem 'factory_girl'
  gem 'faker'
  gem 'fakeweb'
  # gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'pickle'
  gem 'ruby-debug', '0.10.0' # 0.10.1 introduces a interaction/bug with capistrano 2.x
  gem 'spork', '~> 0.8'
  gem 'shoulda'
  gem 'timecop'
  gem 'watchr'
  gem 'mocha'
  gem 'redgreen'
end

gem 'mysql2', '< 0.3'
