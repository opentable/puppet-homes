#!/usr/bin/env sh

bundle exec rake test

RS_SET=ubuntu-server-12042-x64 RS_DEBUG=yes bundle exec rspec spec/acceptance
RS_SET=centos-64-x64 RS_DEBUG=yes bundle exec rspec spec/acceptance
