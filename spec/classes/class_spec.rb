require 'spec_helper'

describe 'pip' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "pip class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('pip::params') }
          it { is_expected.to contain_class('pip::install').that_comes_before('pip::config') }
          it { is_expected.to contain_class('pip::config') }

          it { is_expected.to contain_package('pip').with_ensure('installed') }
        end
      end
    end
  end

  describe "empty global config without pypi repo argument" do
    it { is_expected.to contain_file('/etc/pip.conf').with_content(/^# File Managed by Puppet$/) }
  end

  describe "should honor parameters" do
    let(:params) do
      {
        :pypi_repo => 'http://devpi.fqdn:3141/repo/base/+simple/',
        :package_ensure => 'latest'
      }
    end
    it { is_expected.to contain_package('pip').with_ensure('latest') }
    it do
      is_expected.to contain_file('/etc/pip.conf') \
        .with_content("# File Managed by Puppet\n[global]\ntrusted-host = devpi.fqdn\nindex-url = http://devpi.fqdn:3141/repo/base/+simple/\n")
    end
  end
end
