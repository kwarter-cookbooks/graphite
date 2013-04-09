template "/etc/init.d/carbon-cache" do
  source "carbon-cache.init.erb"
  variables(
    :dir     => node['graphite']['base_dir'],
    :user    => node['graphite']['user']
  )
  mode 00744
end

service "carbon-cache" do
  action [:enable, :start]
end
