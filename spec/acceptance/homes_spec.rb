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
  
  #context 'user ensure absent' do
  #  it 'should remove the user' do
  #    pp = <<-EOS
  #    $myuser = { 
  #      'testuser' => { 'shell' => '/bin/bash' }
  #    }
  #    
  #    homes { 'testuser':
  #      user => $myuser
  #    }
  #    EOS
  #    
  #    p2 = <<-EOS
  #    $myuser = { 
  #      'testuser' => { 'shell' => '/bin/bash' }
  #    }
  #    
  #    homes { 'testuser':
  #      ensure => 'absent',
  #      user => $myuser
  #    }
  #    EOS
  #    
  #    apply_manifest(pp, :catch_failures => true)
  #    expect(apply_manifest(p2, :catch_failures => true).exit_code).to be_zero
  #
  #  end
  #  
  #  describe user('testuser') do
  #    it { should_not exist }
  #  end
  #      
  #  describe file('/home/testuser') do
  #    it { should_not be_directory }
  #  end
  #end
end