require 'spec_helper'

describe 'homes' do
  
  myuser = { 
    'testuser' => { 'groups' => ['testgroup1', 'testgroup2'] }
  }
  
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "homes class without any parameters on #{osfamily}" do
        let(:title) { "supported os" }
        let :params do 
          { 'user' =>  myuser, 'ssh_key' => 'xxx' }
        end
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'homes class without any parameters on Solaris/Nexenta' do
      let(:title) { "unsupported os" }
      let :params do 
        { 'user' =>  myuser, 'ssh_key' => 'xxx' }
      end
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should have_resource_count(1) }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
  
  context 'configure the user and public key' do
    describe 'pass variables to homes::home' do
      let(:title) { "configure the user and public key" }
      let :params do 
        { 'user' =>  myuser, 'ssh_key' => 'xxx' }
      end
      let(:facts) {{
        :osfamily => 'Debian'
      }}
      
      it { should contain_homes__home('create home for testuser') }
      it { should contain_homes__ssh__public('auth_keys for testuser') }
    end
  end
  
  context 'configure the user without a public key' do
    describe 'pass variables to homes::home' do
      let(:title) { "configure the user without a public key" }
      let :params do 
        { 'user' =>  myuser }
      end
      let(:facts) {{
        :osfamily => 'Debian'
      }}
      
      it { should contain_homes__home('create home for testuser') }
      it { should_not contain_homes__ssh__public('auth_keys for testuser') }
    end    
  end

  describe 'ensure that we can cannot set a key type other than ssh-rsa or ssh-dsa' do
    let :title do "testing ssky key type" end
    let :params do
      { 'user' =>  myuser, 'ssh_key' => 'wSlD2thaMRreEXOc9vFZd0', 'ssh_key_type' => 'ecdsa-sha2-nistp384' }
    end
    let(:facts) {{
        :osfamily => 'Debian'
    }}

    it do
      expect {
        should contain_define('homes')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'Keytype not supported' }
    end

  end
  
end
