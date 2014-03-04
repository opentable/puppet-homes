require 'spec_helper'

describe 'homes::ssh::private', :type => :define do
  context 'manage the ssh private key' do
    
    describe 'pull the private key from locally mapped keystore' do
      let :title do "private key" end
      let :params do 
        { 'name' => 'keyfile_rsa', 'username' => 'testuser', 'keystore' =>  '/var/lib/ot-keystore' }
      end
      
      it { should contain_file('/home/testuser/.ssh/keyfile_rsa').with(
         'ensure' => 'present',
         'source' => '/var/lib/ot-keystore/keyfile_rsa',
         'mode'   => '0600'
      )}
    end
  end
  
end