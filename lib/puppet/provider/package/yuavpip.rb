# Puppet package provider for Python's `pip` package management frontend.
# <http://pip.openplans.org/>

require 'puppet/util/package'
require 'puppet/provider/package/pip'

Puppet::Type.type(:package).provide :yuavpip,
  :parent => :pip do

  desc "Python packages via `pip`.

  This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip.
  These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
  or an array where each element is either a string or a hash."

  def latest

    if Puppet::Util::Package.versioncmp(Facter.value(:pip_version), '1.5.0') == -1 # a < b
      # Pip version lookup not working before pip version 1.5
      # Fall back to PyPI lookup implemented by Puppetlabs
      return super
    end

    # Patched latest function also allows for custom PyPi repos.
    pip_cmd = which(self.class.cmd) or return nil
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

end
