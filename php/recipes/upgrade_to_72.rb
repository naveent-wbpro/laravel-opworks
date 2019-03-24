case node[:platform]
when "debian", "ubuntu"
  execute "add_repo" do
    user "root"
    command "add-apt-repository ppa:ondrej/php"
    notifies :run, 'execute[apt_update]', :immediately
  end

  execute "apt_update" do
    user "root"
    command "apt-get update"
    notifies :run, 'execute[apt_install]', :immediately
  end

  execute "apt_install" do
    user "root"
    command "apt-get -y --force-yes install php7.2 php7.2-cli php7.2-common php7.2-mbstring  php7.2-mysql php7.2-xml php7.2-curl php7.2-json php7.2-opcache php7.2-zip php7.2-fpm libapache2-mod-php7.2"
    notifies :run, 'execute[disable_php5_apache]', :delayed
  end

  execute "disable_php5_apache" do
    user "root"
    command "a2dismod php5"
    notifies :run, 'execute[enable_php72_apache]', :immediately
  end

  execute "enable_php72_apache" do
    user "root"
    command "a2enmod php7.2"
    notifies :run, 'execute[restart_apache]', :immediately
  end

  execute "restart_apache" do
    user "root"
    command "service apache2 restart"
  end
end
