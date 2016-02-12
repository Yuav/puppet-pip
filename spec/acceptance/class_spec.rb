require 'spec_helper_acceptance'

describe 'pip class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'pip': }
        package { 'Django':
          provider => 'yuavpip',
          require => Class['pip'],
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, { :catch_failures => true, :debug => true})
      apply_manifest(pp, {
        :catch_changes => true,
        :debug => true,
        :environment => {
          # Workaround for bug: https://tickets.puppetlabs.com/browse/BKR-699
          'PATH' => '/opt/puppet-git-repos/hiera/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'
        }
      })
    end

    describe package('python-pip') do
      it { is_expected.to be_installed }
    end

    # Serverspec test is broken for pip 1.0, since it doesn't have `pip list` command
    #describe package('Django') do
    #  it { should be_installed.by('pip') }
    #end
  end
end
