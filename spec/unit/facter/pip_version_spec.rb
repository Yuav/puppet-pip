require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  let(:output) { <<-EOS
    pip 1.0.1 from /usr/local/lib/python2.7/dist-packages (python 2.7)
EOS
  }

  let(:output8) { <<-EOS
    pip 8.0.1 from /usr/local/lib/python2.7/dist-packages (python 2.7)
EOS
  }

  describe "pip_version" do
    context 'returns pip version when pip present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with("pip").returns(true)
        Facter::Util::Resolution.expects(:exec).with("pip --version").returns(output)
        expect(Facter.value(:pip_version)).to eq("1.0.1")
      end

      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with("pip").returns(true)
        Facter::Util::Resolution.expects(:exec).with("pip --version").returns(output8)
        expect(Facter.value(:pip_version)).to eq("8.0.1")
      end
    end

    context 'returns nil when pip not present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with("pip").returns(false)
        expect(Facter.value(:pip_version)).to eq(nil)
      end
    end

  end
end