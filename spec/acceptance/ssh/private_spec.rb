require 'spec_helper_acceptance'

describe 'homes::ssh::private defintion', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  context 'valid parameters' do
    it 'should work with no errors' do
      pp = <<-EOS

      $myuser = {
        'testuser' => { 'shell' => '/bin/bash' }
      }


      file { '/var/lib/keystore/':
        ensure => directory
      }

      file { '/var/lib/keystore/id_rsa':
        ensure => present,
        content => "xxx"
      }

      file { '/home/testuser/.ssh':
        ensure => directory
      }

      homes { 'testuser':
        user => $myuser
      }

      homes::ssh::private { 'testuser':
        key_name => 'id_rsa',
        username => 'testuser',
        key_store => '/var/lib/keystore'
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero

    end

    describe user('testuser') do
      it { should exist }
    end

    describe file('/home/testuser/.ssh/id_rsa') do
      it { should be_file }
    end
  end
end
