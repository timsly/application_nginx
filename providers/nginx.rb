include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do
end

action :before_deploy do
end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
  template "nginx_tempalte_for_#{new_resource.name}" do
    path "#{node[:nginx][:dir]}/sites-available/#{new_resource.name}"
    cookbook new_resource.template ? new_resource.cookbook_name.to_s : 'application_nginx'
    source new_resource.template || 'nginx_site.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables({
      application_name: new_resource.name,
      root: ::File.join(new_resource.path, 'current', 'public'),
    }.merge(new_resource.variables))
  end
  
  with_context new_resource.application_provider.run_context do
    nginx_site new_resource.name
  end
end

action :after_restart do
end

def with_context(context)
  saved_run_context = @run_context
  @run_context = context
  yield
  @run_context = saved_run_context
end
