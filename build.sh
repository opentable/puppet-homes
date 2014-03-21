#!/usr/bin/env sh

bundle exec rake test

BEAKER_SET=ubuntu-server-10044-x64 BEAKER_DEBUG=yes bundle exec rspec spec/acceptance
BEAKER_SET=ubuntu-server-12042-x64 BEAKER_DEBUG=yes bundle exec rspec spec/acceptance
BEAKER_SET=ubuntu-server-1310-x64 BEAKER_DEBUG=yes bundle exec rspec spec/acceptance

BEAKER_SET=centos-510-x64 BEAKER_DEBUG=yes bundle exec rspec spec/acceptance
BEAKER_SET=centos-64-x64 BEAKER_DEBUG=yes bundle exec rspec spec/acceptance
