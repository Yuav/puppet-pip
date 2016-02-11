require 'spec_helper_acceptance'

describe 'pip class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class {'pip': }
        package { 'Django':
          provider => 'yuavpip',
          require => Class['pip'],
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, { :catch_failures => true, :debug => true})
      shell('hash -r') # Clear pip path cache from Bash shell
      shell('which -a pip') # Verify PIP path
      apply_manifest(pp, { :catch_changes  => true, :debug => true})
    end

    describe package('python-pip') do
      it { is_expected.to be_installed }
    end

    describe package('Django') do
      it { should be_installed.by('pip') }
    end
  end
end
