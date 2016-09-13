require 'spec_helper_acceptance'

describe 'rngd' do

  case fact('osfamily')
  when 'RedHat'
    service = 'rngd'
  when 'Debian'
    service = 'rng-tools'
  end

  it 'should work with no errors' do

    pp = <<-EOS
      class { '::rngd':
        hwrng_device => '/dev/urandom',
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe file('/etc/default/rng-tools'), :if => fact('osfamily') == 'Debian' do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^HRNGDEVICE="\/dev\/urandom"$/ }
  end

  describe file('/etc/sysconfig/rngd'), :if => (fact('osfamily') == 'RedHat' and fact('operatingsystemmajrelease') != '5') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^EXTRAOPTIONS="-r \/dev\/urandom"$/ }
  end

  describe file('/etc/systemd/system/rngd.service.d/override.conf'), :if => (fact('osfamily') == 'RedHat' and fact('operatingsystemmajrelease') > '6') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:sha256sum) { should eq 'cb063edc0c2891008c930c1da1f7187b3eeb5521602939678bb0f2f4e2977259' }
  end

  describe service(service), :if => (fact('osfamily') == 'RedHat' and fact('operatingsystemmajrelease').to_i > 5) do
    it { should be_enabled }
    it { should be_running }
  end

  # Debian doesn't support 'service rngd status'
  describe service(service), :if => fact('osfamily') == 'Debian' do
    it { should be_enabled }
  end

  describe process('rngd') do
    it { should be_running }
    its(:args) { should match /-r \/dev\/urandom/ }
  end
end
