require 'spec_helper'

describe 'rngd' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it do
      expect { subject }.to raise_error(/not supported on an Unsupported/)
    end
  end

  context 'on RedHat' do
    let(:facts) do
      {
        :osfamily => 'RedHat'
      }
    end

    context 'version 5', :compile do
      let(:facts) do
        super().merge(
          {
            :operatingsystemmajrelease => 5,
          }
        )
      end

      it do
        should contain_class('rngd')
        should contain_package('rng-utils')
        should_not contain_service('rngd')
      end
    end

    [6, 7].each do |version|
      context "version #{version}", :compile do
        let(:facts) do
          super().merge(
            {
              :operatingsystemmajrelease => version,
            }
          )
        end

        it do
          should contain_class('rngd')
          should contain_package('rng-tools')
          should contain_service('rngd').with(
            'ensure' => 'running',
            'enable' => true
          )
        end
      end
    end
  end
end
