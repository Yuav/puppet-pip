#! /usr/bin/env ruby
require 'spec_helper'

provider_class = Puppet::Type.type(:package).provider(:yuavpip)

describe provider_class do

  let(:real_package_version_output) { <<-EOS
    Collecting real-package==versionplease
      Could not find a version that satisfies the requirement real-package==versionplease (from versions: 1.1.3, 1.2, 1.9b1)
    No matching distribution found for real-package==versionplease
    EOS
  }

  let(:real_package_version_io) { StringIO.new(real_package_version_output) }

  let(:fake_package_version_output) { <<-EOS
    Collecting fake-package==versionplease
      Could not find a version that satisfies the requirement fake-package==versionplease (from versions: )
    No matching distribution found for fake-package==versionplease
    EOS
  }

  let(:fake_package_version_io) { StringIO.new(fake_package_version_output) }

  before do
    @resource = Puppet::Resource.new(:package, "fake_package")
    @provider = provider_class.new(@resource)

    # Fallback to old method for old Pip
    @client = stub_everything('client')
    @client.stubs(:call).with('package_releases', 'real_package').returns(["1.3", "1.2.5", "1.2.4"])
    @client.stubs(:call).with('package_releases', 'fake_package').returns([])
    XMLRPC::Client.stubs(:new2).returns(@client)

  end

  describe "latest" do

    context "with pip version < 1.5" do

      before :each do
        Facter.clear
        Facter.stubs(:fact).with(:pip_version).returns Facter.add(:pip_version) { setcode { '1.0.1' } }
      end

      it "should find a version number for real_package" do
        parent_provider_class = Puppet::Type.type(:package).provider(:pip)
        @resource[:name] = "real_package"
        expect(@provider.latest).to eq('1.3')
      end

      it "should not find a version number for fake_package" do
        @resource[:name] = "fake_package"
        expect(@provider.latest).to eq(nil)
      end

      it "should handle a timeout gracefully" do
        @resource[:name] = "fake_package"
        @client.stubs(:call).raises(Timeout::Error)
        expect { @provider.latest }.to raise_error(Puppet::Error)
      end

    end

    context "with pip version >= 1.5" do

      # For Pip 1.5 and above, you can get a version list from CLI - which allows for native pip behavior
      # with regards to custom repositories, proxies and the like

      before :each do
        Facter.clear
        Facter.stubs(:fact).with(:pip_version).returns Facter.add(:pip_version) { setcode { '1.5.0' } }
      end

      it "should find a version number for real_package" do
        Puppet::Util::Execution.expects(:execpipe).with(["/usr/local/bin/pip", "install", "real_package==versionplease"]).yields(real_package_version_io).once
        @resource[:name] = "real_package"
        latest = @provider.latest
        expect(latest).to eq('1.9b1')
      end

      it "should not find a version number for fake_package" do
        Puppet::Util::Execution.expects(:execpipe).with(["/usr/local/bin/pip", "install", "fake_package==versionplease"]).yields(fake_package_version_io).once
        @resource[:name] = "fake_package"
        expect(@provider.latest).to eq(nil)
      end
    end
  end

end