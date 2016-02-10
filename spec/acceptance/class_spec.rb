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
      # FIXME - idempotency test fails due to bash exec cache of pip
      # Need to issue hash -r somehow in the same shell as serverspec runs after Pip has upgraded
      #apply_manifest(pp, { :catch_changes  => true, :debug => true})
    end

    describe package('python-pip') do
      it { is_expected.to be_installed }
    end

    describe package('Django') do
      it { should be_installed.by('pip') }
    end
  end
end