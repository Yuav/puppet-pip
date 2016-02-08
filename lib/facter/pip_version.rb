Facter.add("pip_version") do
  setcode do
    if Facter::Util::Resolution.which('pip')
      v = Facter::Util::Resolution.exec('pip --version').strip.match(/^pip (\d+\.\d+\.?\d*).*$/)[1]
      puts v
      v
    end
  end
end
