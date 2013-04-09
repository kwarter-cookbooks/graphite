
include_recipe "runit"

runit_service "graphite-web" do
  finish true
end


include_recipe 'nginx'

if node['graphite']['nginx']['ssl']
  proxy = data_bag_item('monitor', 'proxy')

  directory File.join(node['nginx']['dir'], 'ssl') do
    owner 'root'
    group 'root'
    mode '0755'
  end

  %w(key cert).each do |item|
    file File.join(node['nginx']['dir'], 'ssl', "graphite.#{item}") do
      content proxy['ssl'][item]
      mode 0644
    end
  end

end

template File.join(node['nginx']['dir'], 'sites-available', 'graphite') do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables :ssl_key  => File.join(node['nginx']['dir'], 'ssl', 'graphite.key'),
            :ssl_cert => File.join(node['nginx']['dir'], 'ssl', 'graphite.crt')
  notifies :reload, resources(:service => 'nginx')
end

nginx_site 'sensu' do
  enable true
end
