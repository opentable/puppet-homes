require 'spec_helper'

describe 'homes::config', :type => :define do
  
  myuser = { 
    'testuser' => { 'groups' => ['testgroup1', 'testgroup2'] }
  }
  
  context 'manage the users' do
    
    describe 'ensure that the user and home directory exists' do
      
      let :title do "user exists" end
      let :params do 
        { 'user' =>  myuser, 'ssh_key' => 'xxx' }
      end
      it { should compile.with_all_deps }
      
      it { should contain_user('testuser').with(
        'groups' => ['testgroup1', 'testgroup2']
      ) }
      
      it { should contain_file('/home/testuser').with(
        'ensure' => 'directory',
        'owner'  => 'testuser',
        'mode'   => '0600',
      )}
      
      #TODO: add ensure
    end
  end
  
  context 'manage the ssh public key' do
     
    describe 'ensure the .ssh directory exists' do
      let :title do "directory exists" end
      let :params do 
        { 'user' =>  myuser, 'ssh_key' => 'xxxxx' }
      end
      
      it { should contain_file('/home/testuser/.ssh').with(
        'ensure' => 'directory',
        'owner'  => 'testuser',
        'mode'   => '0600',
        'require' => "File[/home/testuser]"
      )}
    end
    
    describe 'ensure that the public key exists' do
      let :title do "key exists" end
      let :params do 
        { 'user' =>  myuser, 'ssh_key' => 'xxxxx' }
      end
      
      it { should contain_ssh_authorized_key('testuser').with(
        'ensure' => 'present',
        'key' => 'xxxxx',
        'target' => '/home/testuser/.ssh/authorized_keys',
        'type' => 'ssh-rsa',
        'user' => 'testuser'
      )}
      
      it { should contain_file('/home/testuser/.ssh/authorized_keys').with(
        'ensure' => 'present',
        'owner'  => 'testuser',
        'mode'   => '0644'
      )}
    end  
  end
  
end