require 'spec_helper'

describe 'pip' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge(:osfamily => 'RedHat')
        end

        context "pip class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('pip::params') }
          #it { is_expected.to contain_class('pip::install').that_comes_before('pip::config') }
          it { is_expected.to contain_class('pip::config') }

          it { is_expected.to contain_package('pip').with_ensure('installed') }
        end
      end
    end
  end

  describe "empty global config without pypi repo argument" do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '7'
      }
    end
    let(:expected_content) do
      <<-EOS
# File Managed by Puppet
[global]
      EOS
    end
    it { is_expected.to contain_file('/etc/pip.conf').with_content(expected_content) }
  end

  describe "should honor parameters" do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '7'
      }
    end
    let(:params) do
      {
        :index_url => 'http://devpi.fqdn:3141/repo/base/+simple/',
        :extra_index_url => 'https://repo.fury.io/yuav/',
        :package_ensure => 'latest'
      }
    end
    let(:expected_content) do
      <<-EOS
# File Managed by Puppet
[global]
trusted-host = devpi.fqdn
index-url = http://devpi.fqdn:3141/repo/base/+simple/
extra-index-url = https://repo.fury.io/yuav/
      EOS
    end
    it { is_expected.to contain_file('/etc/pip.conf').with_content(expected_content) }
    it { is_expected.to contain_package('pip').with_ensure('latest') }
  end
end
