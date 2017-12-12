source ENV['GEM_SOURCE'] || "http://rubygems.org"

ENV['RUBY_VERSION'] = `ruby -v`

group :test do
  gem 'rake', '~> 11.3',                                                          :require => false
  gem 'rspec', '~> 3.5',                                                          :require => false

  if RUBY_VERSION =~ /^1\.9/
    gem 'json_pure', '<= 2.0.1',                                                  :require => false
  end

  if ENV['PUPPET_GEM_VERSION'] =~ /3.4/ && ENV['RUBY_VERSION'] !~ /1.8/
    gem 'puppet-doc-lint', '~> 0.3',                                              :require => false
  end

  gem 'puppetlabs_spec_helper', '~> 1.2',                                         :require => false
  gem 'puppet-lint', '== 2.0.2',                                                  :require => false
  gem 'puppet-syntax', '~> 2.0',                                                  :require => false
  gem 'rspec-puppet', '~> 2.0',                                                   :require => false
  gem 'puppet-blacksmith', '~> 3.4',                                              :require => false
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
  gem 'specinfra',                                                               :require => false
  gem 'winrm',                                                                   :require => false
  gem 'vagrant-wrapper',                                                         :require => false
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
