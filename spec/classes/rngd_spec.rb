require 'spec_helper'

describe 'rngd' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      it { should contain_anchor('rngd::begin') }
      it { should contain_anchor('rngd::end') }
      it { should contain_class('rngd') }
      it { should contain_class('rngd::config') }
      it { should contain_class('rngd::install') }
      it { should contain_class('rngd::params') }
      it { should contain_class('rngd::service') }

      case facts[:osfamily]
      when 'RedHat'
        case facts[:operatingsystemmajrelease]
        when '5'
          it { should contain_package('rng-utils') }
          it { should_not contain_service('rngd') }
        when '7'
          it { should contain_exec('systemctl daemon-reload') }
          it { should contain_file('/etc/systemd/system/rngd.service.d') }
          it { should contain_file('/etc/systemd/system/rngd.service.d/override.conf') }
          it { should contain_package('rng-tools') }
          it { should contain_service('rngd') }
        else
          it { should contain_package('rng-tools') }
          it { should contain_service('rngd') }
        end
        it { should contain_file('/etc/sysconfig/rngd') }
      when 'Debian'
        it { should contain_file('/etc/default/rng-tools') }
        it { should contain_package('rng-tools') }
        it { should contain_service('rng-tools') }
      end
    end
  end
end
