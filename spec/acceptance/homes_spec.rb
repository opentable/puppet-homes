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
      $myuser = {
        'testuser' => { 'shell' => '/bin/bash' }
      }

      homes { 'testuser':
        ensure => 'absent',
        user => $myuser
      }
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
  end
end