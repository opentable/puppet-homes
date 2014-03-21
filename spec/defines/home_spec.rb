require 'spec_helper'

describe 'homes::home', :type => :define do
  
  context 'manage the users' do

    myuser = {
        'testuser' => { 'groups' => ['testgroup1', 'testgroup2'] }
    }

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

  context 'remove default groups where not applicable' do
    myuser = {
        'testuser' => { 'ensure' => 'present', 'groups' => ['sudo', 'wheel'] }
    }

    describe 'ensure that the sudo group is not applied to the user on centos' do
      let(:facts) { {
          :osfamily  => 'RedHat'
      } }
      let :title do "user exists" end
      let :params do
        { 'user' =>  myuser }
      end
      it { should compile.with_all_deps }

      it { should contain_user('testuser').with(
        'groups' => ['wheel']
      ) }
    end

    describe 'ensure that the wheel group is not applied to the user on ubuntu' do
      let(:facts) { {
          :osfamily  => 'Debian'
      } }
      let :title do "user exists" end
      let :params do
        { 'user' =>  myuser }
      end
      it { should compile.with_all_deps }

      it { should contain_user('testuser').with(
        'groups' => ['sudo']
      ) }
    end
  end

end

