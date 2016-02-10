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

          it { is_expected.to contain_package('pip').with_ensure('latest') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'pip class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('pip') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
