require 'spec_helper'

describe 'homes::home', :type => :define do
  
  myuser = { 
    'testuser' => { 'groups' => ['testgroup1', 'testgroup2'] }
  }
  
  context 'manage the users' do
    
    describe 'ensure that the user and home directory exists' do
      
      let :title do "user exists" end
      let :params do 
        { 'user' =>  myuser }
      end
      it { should compile.with_all_deps }
      
      it { should contain_user('testuser').with(
        'groups' => ['testgroup1', 'testgroup2']
      ) }
      
      it { should contain_file('/home/testuser').with(
        'ensure' => 'directory',
        'owner'  => 'testuser',
        'mode'   => '0600'
      )}
    end
  end
  
end