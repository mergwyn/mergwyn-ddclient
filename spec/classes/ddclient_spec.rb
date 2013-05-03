require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'ddclient' do

  let(:title) { 'ddclient' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('ddclient').with_ensure('present') }
    it { should contain_service('ddclient').with_ensure('running') }
    it { should contain_service('ddclient').with_enable('true') }
  end

  describe 'Test ddclient.conf managed through file - source' do
    let(:params) { {:hosts_config => 'file', :source => 'puppet:///modules/ddclient/spec' } }
    it { should contain_file('ddclient.conf').with_source('puppet:///modules/ddclient/spec') }
    it { should contain_file('ddclient.conf').without_content }
  end

  describe 'Test ddclient.conf managed through file - template' do
    let(:facts) { {:operatingsystem => 'Debian'} }
    let(:params) { {:hosts_config => 'file', :template => 'ddclient/ddclient.conf.erb',
                    :mailto => 'my@shiny.email', 
                    :server => 'some.ddns.server',
                    :login => 'me',
                    :password => 'secret',
                    :protocol => 'proto',
                    :hostname => 'rspec.example42.com'} }
    it { should contain_file('ddclient.conf').without_source }
    it { should contain_file('ddclient.conf').with_content(/server=some.ddns.server/) }
    it { should contain_file('ddclient.conf').with_content(/login=me,/) }
    it { should contain_file('ddclient.conf').with_content(/password=secret,/) }
    it { should contain_file('ddclient.conf').with_content(/protocol=proto,/) }
    it { should contain_file('ddclient.conf').with_content(/rspec.example42.com/) }
  end

  describe 'Test ddclient.conf managed throuh file - custom template' do
    let(:params) { {:hosts_config => 'file', :template => 'ddclient/spec.erb', :options => { 'opt_a' => 'value_a' } } }
    it { should contain_file('ddclient.conf').with_content(/fqdn: rspec.example42.com/) }
    it { should contain_file('ddclient.conf').without_source }
    it { should contain_file('ddclient.conf').with_content(/value_a/) }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('ddclient').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring' do
    let(:params) { {:monitor => true } }
    it { should contain_package('ddclient').with_ensure('present') }
    it { should contain_service('ddclient').with_ensure('running') }
    it { should contain_service('ddclient').with_enable('true') }
    it { should contain_monitor__process('ddclient_process').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true} }
    it 'should remove Package[ddclient]' do should contain_package('ddclient').with_ensure('absent') end
    it 'should stop Service[ddclient]' do should contain_service('ddclient').with_ensure('stopped') end
    it 'should not enable at boot Service[ddclient]' do should contain_service('ddclient').with_enable('false') end
    it { should contain_monitor__process('ddclient_process').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true} }
    it { should contain_package('ddclient').with_ensure('present') }
    it 'should stop Service[ddclient]' do should contain_service('ddclient').with_ensure('stopped') end
    it 'should not enable at boot Service[ddclient]' do should contain_service('ddclient').with_enable('false') end
    it { should contain_monitor__process('ddclient_process').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true} }
    it { should contain_package('ddclient').with_ensure('present') }
    it { should_not contain_service('ddclient').with_ensure('present') }
    it { should_not contain_service('ddclient').with_ensure('absent') }
    it 'should not enable at boot Service[ddclient]' do should contain_service('ddclient').with_enable('false') end
    it { should contain_monitor__process('ddclient_process').with_enable('false') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true, :monitor => true} }
    it { should contain_package('ddclient').with_noop('true') }
    it { should contain_service('ddclient').with_noop('true') }
    it { should contain_monitor__process('ddclient_process').with_noop('true') }
    it { should contain_monitor__process('ddclient_process').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:hosts_config => 'file', 
                    :template => "ddclient/spec.erb" , 
                    :options => { 'opt_a' => 'value_a' } } }
    it { should contain_file('ddclient.conf').with_content(/fqdn: rspec.example42.com/) } 
    it { should contain_file('ddclient.conf').with_content(/value_a/) }
  end

  describe 'Test customizations - source without hosts_config' do
    let(:params) { {:source => 'puppet:///modules/ddclient/spec'} }
    it { expect { should contain_file('ddclient.conf').to raise_error(Puppet::Error,//) } }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "ddclient::spec" } }
  end
  describe 'Test service autorestart' do
    let(:params) { {:hosts_config => 'file', :service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'ddclient.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('ddclient').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('ddclient_process').with_tool('puppi') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:puppi => true, :monitor => "yes" , :monitor_tool => "puppi"} }
    it { should contain_monitor__process('ddclient_process').with_tool('puppi') }
    it { should contain_puppi__ze('ddclient').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('ddclient_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :ddclient_monitor => true , :ipaddress => '10.42.42.42' } }
    it 'should honour module specific vars' do should contain_monitor__process('ddclient_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ddclient_monitor => true , :ipaddress => '10.42.42.42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('ddclient_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true} }
    it 'should honour passed params over global vars' do should contain_monitor__process('ddclient_process').with_enable('true') end
  end

end

