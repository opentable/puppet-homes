require 'spec_helper'

describe 'homes::ssh::public', :type => :define do
  context 'manage the ssh public key' do

    describe 'ensure the .ssh directory exists' do
      let :title do "directory exists" end
      let :params do
        { 'username' => 'testuser', 'home' => '', 'ssh_key' => 'xxxxx', 'ssh_key_type' => 'ssh-rsa' }
      end

      it { should contain_file('/home/testuser/.ssh').with(
        'ensure' => 'directory',
        'owner'  => 'testuser',
        'mode'   => '0600',
        'require' => "File[/home/testuser]"
      )}
    end

    describe 'ensure that the ssh-rsa public key exists' do
      let :title do "key exists" end
      let :params do
        { 'username' => 'testuser', 'home' => '', 'ssh_key' => 'xxxxx', 'ssh_key_type' => 'ssh-rsa' }
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
        'mode'   => '0600'
      )}
    end

    describe 'ensure that the ssh-dsa public key exists' do
      let :title do "key exists" end
      let :params do
        { 'username' => 'testuser', 'home' => '', 'ssh_key' => 'xxxxx', 'ssh_key_type' => 'ssh-dsa' }
      end

      it { should contain_ssh_authorized_key('testuser').with(
        'ensure' => 'present',
        'key' => 'xxxxx',
        'target' => '/home/testuser/.ssh/authorized_keys',
        'type' => 'ssh-dsa',
        'user' => 'testuser'
      )}

      it { should contain_file('/home/testuser/.ssh/authorized_keys').with(
        'ensure' => 'present',
        'owner'  => 'testuser',
        'mode'   => '0600'
      )}
    end


  end
end
