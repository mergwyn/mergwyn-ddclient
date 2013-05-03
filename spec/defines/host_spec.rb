require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'ddclient::host' do

  let(:title) { 'ddclient::host' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :hosts_config => 'file', :config_file => '/etc/ddclient.conf', :hosts_template_header => 'ddclient/concat/ddclient.conf-header.erb', :concat_basedir => '/var/lib/puppet/concat'} }

  describe 'Test basic ddclient.conf is created' do
    let(:params) { { :name     => 'sample1',
                     :server   => 'someserver1',
                     :login    => 'me',
                     :password => 'secret',
                     :protocol => 'myprot',
                     :enable   => true, } }
    it { should include_class('concat::setup') }
    it { should contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(/server=someserver1/) }
    it { should contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(/login=me/) }
    it { should contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(/password=secret/) }
    it { should contain_concat__fragment('ddclient_host_sample1').with_target('/etc/ddclient.conf').with_content(/protocol=myprot/) }
  end
end
