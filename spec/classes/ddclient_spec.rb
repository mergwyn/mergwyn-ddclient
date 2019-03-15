require 'spec_helper'

describe 'ddclient' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'ddclient' }
      let(:node) { 'rspec.example42.com' }

      # it { is_expected.to compile }

      describe 'Test standard installation' do
        it { is_expected.to contain_package('ddclient').with_ensure('present') }
        it { is_expected.to contain_service('ddclient').with_ensure('running') }
        it { is_expected.to contain_service('ddclient').with_enable('true') }
      end

      describe 'Test ddclient.conf config undefined' do
        let(:params) { { hosts_config: '' } }

        it { is_expected.not_to contain_file('ddclient.conf') }
      end

      describe 'Test ddclient.conf managed through file - source' do
        let(:params) { { hosts_config: 'file', source: 'puppet:///modules/ddclient/spec' } }

        it { is_expected.to contain_file('ddclient.conf').with_source('puppet:///modules/ddclient/spec') }
        it { is_expected.to contain_file('ddclient.conf').without_content }
      end

      describe 'Test ddclient.conf managed through file - template' do
        let(:params) do {
            hosts_config: 'file', template: 'ddclient/ddclient.conf.erb',
            mailto: 'my@shiny.email',
            server: 'some.ddns.server',
            login: 'me',
            password: 'secret',
            protocol: 'proto',
            hostname: 'rspec.example42.com'
          }
        end

        it { is_expected.to contain_file('ddclient.conf').without_source }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{server=some.ddns.server}) }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{login=me,}) }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{password='secret',}) }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{protocol=proto,}) }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{rspec.example42.com}) }
      end

      describe 'Test ddclient.conf managed through concat - template' do
        let(:facts) do
          os_facts.merge(concat_basedir: '/var/lib/puppet/concat')
        end
        let(:params) do {
            hosts_config: 'concat',
            hostname: 'myhost',
            server: 'some.ddns.server',
            login: 'me',
            password: 'secret',
            protocol: 'proto'
          }
        end

        it { is_expected.not_to contain_file('ddclient.conf') }
        it { is_expected.to contain_ddclient__host('myhost') }
        it { is_expected.to contain_ddclient__host('myhost').with_name('myhost') }
        it { is_expected.to contain_ddclient__host('myhost').with_server('some.ddns.server') }
        it { is_expected.to contain_ddclient__host('myhost').with_login('me') }
        it { is_expected.to contain_ddclient__host('myhost').with_password('secret') }
        it { is_expected.to contain_ddclient__host('myhost').with_protocol('proto') }
      end

      describe 'Test ddclient.conf managed throuh file - custom template' do
        let(:params) { { hosts_config: 'file', template: 'ddclient/spec.erb', options: { 'opt_a' => 'value_a' } } }

        it { is_expected.to contain_file('ddclient.conf').with_content(%r{fqdn: rspec.example42.com}) }
        it { is_expected.to contain_file('ddclient.conf').without_source }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{value_a}) }
      end

      describe 'Test installation of a specific version' do
        let(:params) { { version: '1.0.42' } }

        it { is_expected.to contain_package('ddclient').with_ensure('1.0.42') }
      end

      describe 'Test standard installation with monitoring' do
        let(:params) { { monitor: true } }

        it { is_expected.to contain_package('ddclient').with_ensure('present') }
        it { is_expected.to contain_service('ddclient').with_ensure('running') }
        it { is_expected.to contain_service('ddclient').with_enable('true') }
        it { is_expected.to contain_monitor__process('ddclient_process').with_enable('true') }
      end

      describe 'Test decommissioning - absent' do
        let(:params) { { absent: true, monitor: true } }

        it 'removes Package[ddclient]' do is_expected.to contain_package('ddclient').with_ensure('absent') end
        it 'stops Service[ddclient]' do is_expected.to contain_service('ddclient').with_ensure('stopped') end
        it 'does not enable at boot Service[ddclient]' do is_expected.to contain_service('ddclient').with_enable('false') end
        it { is_expected.to contain_monitor__process('ddclient_process').with_enable('false') }
      end

      describe 'Test decommissioning - disable' do
        let(:params) { { disable: true, monitor: true } }

        it { is_expected.to contain_package('ddclient').with_ensure('present') }
        it 'stops Service[ddclient]' do is_expected.to contain_service('ddclient').with_ensure('stopped') end
        it 'does not enable at boot Service[ddclient]' do is_expected.to contain_service('ddclient').with_enable('false') end
        it { is_expected.to contain_monitor__process('ddclient_process').with_enable('false') }
      end

      describe 'Test decommissioning - disableboot' do
        let(:params) { { disableboot: true, monitor: true } }

        it { is_expected.to contain_package('ddclient').with_ensure('present') }
        it { is_expected.not_to contain_service('ddclient').with_ensure('present') }
        it { is_expected.not_to contain_service('ddclient').with_ensure('absent') }
        it 'does not enable at boot Service[ddclient]' do is_expected.to contain_service('ddclient').with_enable('false') end
        it { is_expected.to contain_monitor__process('ddclient_process').with_enable('false') }
      end

      describe 'Test noops mode' do
        let(:params) { { noops: true, monitor: true } }

        it { is_expected.to contain_package('ddclient').with_noop('true') }
        it { is_expected.to contain_service('ddclient').with_noop('true') }
        it { is_expected.to contain_monitor__process('ddclient_process').with_noop('true') }
      end

      describe 'Test customizations - template' do
        let(:params) do {
            hosts_config: 'file',
            template: 'ddclient/spec.erb',
            options: { 'opt_a' => 'value_a' }
          }
        end

        it { is_expected.to contain_file('ddclient.conf').with_content(%r{fqdn: rspec.example42.com}) }
        it { is_expected.to contain_file('ddclient.conf').with_content(%r{value_a}) }
      end

      # describe 'Test customizations - source without hosts_config' do
      #  let(:params) { { source: 'puppet:///modules/ddclient/spec' } }

      #  it { is_expected.to contain_file('ddclient.conf').to raise_error(Puppet::Error, %r{}) }
      # end

      # TODO: add tests
      # describe 'Test customizations - custom class' do
      #   let(:params) { { my_class: 'ddclient::spec' } }
      # end
      describe 'Test service autorestart' do
        let(:params) { { hosts_config: 'file', service_autorestart: false } }

        it 'does not automatically restart the service, when service_autorestart => false' do
          content = catalogue.resource('file', 'ddclient.conf').send(:parameters)[:notify]
          content.should be_nil
        end
      end

      describe 'Test Puppi Integration' do
        let(:params) { { puppi: true, puppi_helper: 'myhelper' } }

        it { is_expected.to contain_puppi__ze('ddclient').with_helper('myhelper') }
      end

      describe 'Test Monitoring Tools Integration' do
        let(:params) { { monitor: true, monitor_tool: 'puppi' } }

        it { is_expected.to contain_monitor__process('ddclient_process').with_tool('puppi') }
      end

      describe 'Test OldGen Module Set Integration' do
        let(:params) { { puppi: true, monitor: true, monitor_tool: 'puppi' } }

        it { is_expected.to contain_monitor__process('ddclient_process').with_tool('puppi') }
        it { is_expected.to contain_puppi__ze('ddclient').with_ensure('present') }
      end

      describe 'Test params lookup' do
        let(:facts) { os_facts.merge(ipaddress: '10.42.42.42') }
        let(:node_params) { { monitor: true } }

        it 'honours top scope global vars' do is_expected.to contain_monitor__process('ddclient_process').with_enable('true') end
      end

      describe 'Test params lookup' do
        let(:facts) { os_facts.merge(ipaddress: '10.42.42.42') }
        let(:node_params) { { monitor: true } }

        it 'honours module specific vars' do is_expected.to contain_monitor__process('ddclient_process').with_enable('true') end
      end

      describe 'Test params lookup' do
        let(:facts) { os_facts.merge(ipaddress: '10.42.42.42') }
        let(:node_params) { { monitor: false, ddclient_monitor: true } }

        it 'honours top scope module specific over global vars' do is_expected.to contain_monitor__process('ddclient_process').with_enable('true') end
      end

      describe 'Test params lookup' do
        let(:facts) { os_facts.merge(ipaddress: '10.42.42.42') }
        let(:node_params) { { monitor: false } }
        let(:params) { { monitor: true } }

        it 'honours passed params over global vars' do is_expected.to contain_monitor__process('ddclient_process').with_enable('true') end
      end
    end
  end
end
