require 'spec_helper_acceptance'

describe 'homes defintion', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  context 'valid user parameter' do
    it 'should work with no errors' do
      pp = <<-EOS
      $myuser = {
        'testuser' => { 'shell' => '/bin/bash' }
      }

      homes { 'testuser':
        user => $myuser
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero

    end

    describe user('testuser') do
      it { should exist }
    end

    describe file('/home/testuser') do
      it { should be_directory }
    end
  end

  context 'user ensure absent' do
    it 'should remove the user' do
      pp = <<-PP
      $myuser = {
        'testuser' => { 'shell' => '/bin/bash' }
      }

      homes { 'testuser':
        user => $myuser
      }
      PP

      p2 = <<-P2

      $test_users = {
        'testuser' => {
          'user' => {
            'testuser' => {
              'shell'  => '/bin/bash',
              'groups' => ['sudo']
            }
          },
          'ssh_key' => 'AAAAAAwWw==',
          'tag' => 'fubar',
          'ensure' => 'absent'
        }
      }
      create_resources('@homes', $test_users)

      Homes<| tag == 'fubar' |>
      P2

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(p2, :catch_failures => true)
      expect(apply_manifest(p2, :catch_failures => true).exit_code).to be_zero

    end

    describe user('testuser') do
      it { should_not exist }
    end

    describe file('/home/testuser') do
      it { should_not be_directory }
    end
  end

  context 'creating a user with a public ssh key' do
    it 'should create the ssh key' do
      pp = <<-PP
      $myuser = {
        'testuser' => { 'shell' => '/bin/bash' }
      }

      homes { 'testuser':
        user => $myuser,
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4U/G9Idqy1VvYEDCKg3noVChCbIrJAi0D/qMFoGo0EuupIvPX86/l3T4c3pQxvQdWWdK3hf0quCGtDo7vhBubn1o6Srb6AZuhMvx4ZwYEyg6bcp6UDBRcbfZFq9ea020UwExIjoLUceY2UF0m8mjKmd71kwRy+xPgTPmaxTPwWw=='
      }
      PP

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to be_zero
    end

    describe file('/home/testuser/.ssh/authorized_keys') do
      it { should be_file }
      its(:content) { should include('AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4U/G9Idqy1VvYEDCKg3noVChCbIrJAi0D/qMFoGo0EuupIvPX86/l3T4c3pQxvQdWWdK3hf0quCGtDo7vhBubn1o6Srb6AZuhMvx4ZwYEyg6bcp6UDBRcbfZFq9ea020UwExIjoLUceY2UF0m8mjKmd71kwRy+xPgTPmaxTPwWw==') }
    end
  end

  context 'creating a user with ssh_config entries' do
    it 'should create the ssh_config file' do
      pp = <<-PP
      $myuser = {
        'testuser' => { 'shell' => '/bin/bash' }
      }

      $entries = {
        'Host' => { 'ensure' => 'present', 'value' => 'github.com' },
        'HostName' => { 'ensure' => 'present', 'value' => 'github.com' },
        'User' => { 'ensure' => 'present', 'value' => 'testuser' },
        'IdentityFile' => { 'ensure' => 'present', 'value' => '~/.ssh/id_rsa' }
      }

      homes { 'testuser':
        user => $myuser,
        ssh_config_entries => $entries
      }
      PP

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to be_zero
    end

    describe file('/home/testuser/.ssh/config') do
      it { should be_file }
      its(:content) { should match /Host github.com/ }
      its(:content) { should match /HostName github.com/ }
      its(:content) { should match /User testuser/ }
      its(:content) { should match /IdentityFile ~\/\.ssh\/id_rsa/ }
    end
  end
end
