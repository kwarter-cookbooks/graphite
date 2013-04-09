include_recipe "apache2"
include_recipe "apache2::mod_python"

template "#{node['apache']['dir']}/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
end

apache_site "graphite"

apache_site "000-default" do
  enable false
end
