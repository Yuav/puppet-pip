# Puppet package provider for Python's `pip` package management frontend.
# <http://pip.openplans.org/>

require 'puppet/util/package'
require 'puppet/provider/package/pip'

Puppet::Type.type(:package).provide :yuavpip, :parent => :pip do
  desc "Python packages via `pip`.

  This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip.
  These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
  or an array where each element is either a string or a hash."
  def latest
    # Use CLI to allow for custom PyPI repos, proxies etc.
    pip_cmd = which(self.class.cmd) or return nil

    if Puppet::Util::Package.versioncmp(Facter.value(:pip_version), '1.5.4') == -1 # a < b
      Dir.mktmpdir("puppet_pip") do |dir|
        execpipe ["#{pip_cmd}", "install", "#{@resource[:name]}", "-d", "#{dir}", "-v"] do |process|
          process.collect do |line|
            # Using version 0.10.1 (newest of versions: 0.10.1, 0.10, 0.9, 0.8.1, 0.8, 0.7.2, 0.7.1, 0.7, 0.6.1, 0.6, 0.5.2, 0.5.1, 0.5, 0.4, 0.3.1, 0.3, 0.2, 0.1)
            if line =~ /Using version (.+?) \(newest of versions/
              return $1
            end
          end
          return nil
        end
      end
    end

    # Less resource intensive approach for pip version 1.5.4 and above
    execpipe ["#{pip_cmd}", "install", "#{@resource[:name]}==versionplease"] do |process|
      process.collect do |line|
        # Could not find a version that satisfies the requirement Django==versionplease (from versions: 1.1.3, 1.8rc1)
        if line =~ /from versions: /
          textAfterLastMatch = $'
          versionList = textAfterLastMatch.chomp(")\n").split(', ')
          return versionList.last
        end
      end
      return nil
    end
  end

  # Pip can also upgrade pip, but it's not listed in freeze so need to special case it
  def self.instances
    packages = super
    packages << new({:ensure => Facter.value(:pip_version), :name => 'pip', :provider => name})
  end

  # Epel package no longer installs python-pip for RHEL6
  def self.cmd
    "pip"
  end
end
