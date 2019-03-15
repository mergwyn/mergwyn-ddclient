require 'spec_helper'

describe 'ddclient::host' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:title) { 'ddclient::host' }
      let(:node) { 'rspec.example42.com' }
      let(:facts) do
        os_facts.merge(ipaddress: '10.42.42.42',
                       hosts_config: 'file',
                       config_file: '/etc/ddclient.conf',
                       hosts_template_header: 'ddclient/concat/ddclient.conf-header.erb',
                       concat_basedir: '/var/lib/puppet/concat')
      end

      describe 'Test basic ddclient.conf is created' do
        let(:params) do
          { name: 'sample1',
            server: 'someserver1',
            login: 'me',
            password: 'secret',
            protocol: 'myprot',
            enable: true }
        end

        it { is_expected.to contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(%r{server=someserver1}) }
        it { is_expected.to contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(%r{login=me}) }
        it { is_expected.to contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(%r{password='secret'}) }
        it { is_expected.to contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(%r{protocol=myprot}) }
      end
    end
  end
end
