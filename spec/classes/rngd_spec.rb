require 'spec_helper'

describe 'rngd' do
  context 'on unsupported distributions' do
    let(:facts) do
      {
        osfamily: 'Unsupported',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{not supported on an Unsupported}) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('rngd') }
      it { is_expected.to contain_class('rngd::config') }
      it { is_expected.to contain_class('rngd::install') }
      it { is_expected.to contain_class('rngd::params') }
      it { is_expected.to contain_class('rngd::service') }

      case facts[:osfamily]
      when 'RedHat'
        case facts[:operatingsystemmajrelease]
        when '5'
          context 'when on RedHat 5' do
            it { is_expected.to contain_package('rng-utils') }
            it { is_expected.not_to contain_service('rngd') }
          end
        when '7'
          context 'when on RedHat 7' do
            it { is_expected.to contain_exec('systemctl daemon-reload') }
            it { is_expected.to contain_file('/etc/systemd/system/rngd.service.d') }
            it { is_expected.to contain_file('/etc/systemd/system/rngd.service.d/override.conf') }
            it { is_expected.to contain_package('rng-tools') }
            it { is_expected.to contain_service('rngd').with_hasstatus(true) }
            case facts[:selinux]
            when true
              it { is_expected.to contain_file('/etc/systemd/system/rngd.service.d').with_seltype('systemd_unit_file_t') }
              it { is_expected.to contain_file('/etc/systemd/system/rngd.service.d/override.conf').with_seltype('rngd_unit_file_t') }
            end
          end
        else
          context 'when on other RedHat OS' do
            it { is_expected.to contain_package('rng-tools') }
            it { is_expected.to contain_service('rngd') }
          end
        end
        it { is_expected.to contain_file('/etc/sysconfig/rngd') }
      when 'Debian'
        it { is_expected.to contain_file('/etc/default/rng-tools') }
        it { is_expected.to contain_package('rng-tools') }
        case facts[:operatingsystem]
        when 'Ubuntu'
          case facts[:operatingsystemrelease]
          when '12.04', '14.04'
            context 'when on Ubuntu 12.04 & 14.04' do
              it { is_expected.to contain_service('rng-tools').with_hasstatus(false) }
            end
          else
            context 'when on other Ubuntu OS' do
              it { is_expected.to contain_service('rng-tools').with_hasstatus(true) }
            end
          end
        else
          case facts[:operatingsystemmajrelease]
          when '6', '7'
            context 'when on Debian 6 & 7' do
              it { is_expected.to contain_service('rng-tools').with_hasstatus(false) }
            end
          else
            context 'when on other Debian OS' do
              it { is_expected.to contain_service('rng-tools').with_hasstatus(true) }
            end
          end
        end
      end
    end
  end
end
