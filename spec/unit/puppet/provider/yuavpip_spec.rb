#!/usr/bin/env ruby
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

  let(:real_package_version_pip_1_0) { <<-EOS
    Downloading/unpacking fake-package
      Using version 0.10.1 (newest of versions: 0.10.1, 0.10, 0.9, 0.8.1, 0.8, 0.7.2, 0.7.1, 0.7, 0.6.1, 0.6, 0.5.2, 0.5.1, 0.5, 0.4, 0.3.1, 0.3, 0.2, 0.1)
      Downloading real-package-0.10.1.tar.gz (544Kb): 544Kb downloaded
    Saved ./foo/real-package-0.10.1.tar.gz
    Successfully downloaded real-package
    EOS
  }

  let(:real_package_version_pip_1_0_io) { StringIO.new(real_package_version_pip_1_0) }

  let(:fake_package_version_pip_1_0_output) { <<-EOS
  Downloading/unpacking fake-package
    Could not fetch URL http://pypi.python.org/simple/fake_package: HTTP Error 404: Not Found
    Will skip URL http://pypi.python.org/simple/fake_package when looking for download links for fake-package
    Could not fetch URL http://pypi.python.org/simple/fake_package/: HTTP Error 404: Not Found
    Will skip URL http://pypi.python.org/simple/fake_package/ when looking for download links for fake-package
    Could not find any downloads that satisfy the requirement fake-package
  No distributions at all found for fake-package
  Exception information:
  Traceback (most recent call last):
    File "/usr/lib/python2.7/dist-packages/pip/basecommand.py", line 126, in main
      self.run(options, args)
    File "/usr/lib/python2.7/dist-packages/pip/commands/install.py", line 223, in run
      requirement_set.prepare_files(finder, force_root_egg_info=self.bundle, bundle=self.bundle)
    File "/usr/lib/python2.7/dist-packages/pip/req.py", line 948, in prepare_files
      url = finder.find_requirement(req_to_install, upgrade=self.upgrade)
    File "/usr/lib/python2.7/dist-packages/pip/index.py", line 152, in find_requirement
      raise DistributionNotFound('No distributions at all found for %s' % req)
  DistributionNotFound: No distributions at all found for fake-package

  Storing complete log in /root/.pip/pip.log
    EOS
  }

  let(:fake_package_version_pip_1_0_io) { StringIO.new(fake_package_version_pip_1_0_output) }

  before do
    @resource = Puppet::Resource.new(:package, "fake_package")
    @provider = provider_class.new(@resource)
  end

  describe "latest" do

    context "with pip version < 1.5.4" do

      before :each do
        Facter.clear
        Facter.stubs(:fact).with(:pip_version).returns Facter.add(:pip_version) { setcode { '1.0' } }
      end

      it "should find a version number for real_package" do
        Puppet::Util::Execution.expects(:execpipe).yields(real_package_version_pip_1_0_io).once
        #Puppet::Util::Execution.expects(:execpipe).with(array_including("/local/bin/pip", "-d", "real_package", "-v")).yields(real_package_version_pip_1_0_io).once
        @resource[:name] = "real_package"
        latest = @provider.latest
        expect(latest).to eq('0.10.1')
      end

      it "should not find a version number for fake_package" do
        Puppet::Util::Execution.expects(:execpipe).yields(fake_package_version_pip_1_0_io).once
        @resource[:name] = "fake_package"
        expect(@provider.latest).to eq(nil)
      end

    end

    context "with pip version >= 1.5.4" do

      # For Pip 1.5.4 and above, you can get a version list from CLI - which allows for native pip behavior
      # with regards to custom repositories, proxies and the like

      before :each do
        Facter.clear
        Facter.stubs(:fact).with(:pip_version).returns Facter.add(:pip_version) { setcode { '1.5.4' } }
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