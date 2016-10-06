source ENV['GEM_SOURCE'] || "http://rubygems.org"

ENV['RUBY_VERSION'] = `ruby -v`

group :test do
  if ENV['PUPPET_GEM_VERSION'] =~ /3.4/ && ENV['RUBY_VERSION'] !~ /1.8/
    gem 'puppet-doc-lint', :require => false
  end

  gem 'rake',                                                                    :require => false
  gem 'puppet-lint',                                                             :require => false
  gem 'rspec-puppet', '2.0.0',                                                   :require => false
  gem 'puppet-syntax',                                                           :require => false
  gem 'puppetlabs_spec_helper',                                                  :require => false
  gem 'rspec',                                                                   :require => false
  gem 'specinfra',                                                               :require => false
  gem 'winrm',                                                                   :require => false
  gem 'vagrant-wrapper',                                                         :require => false
  gem 'puppet-blacksmith',                                                       :require => false
  gem 'listen', '~> 2.8.3',                                                      :require => false
  gem 'json_pure', '<=2.0.1',                                                    :require => false
end

group :development do
  gem 'guard-rake',                                                              :require => false
  gem 'travis',                                                                  :require => false
  gem 'travis-lint',                                                             :require => false
end

group :system_tests do
  gem 'beaker',                                                                  :require => false
  gem 'beaker-rspec',                                                            :require => false
  gem 'serverspec',                                                              :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '> 3.0.0', '< 4.0.0', :require => false
end

# vim:ft=ruby
