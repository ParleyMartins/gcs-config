wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install curl git jenkins

echo -e $BLUE "Adicionando usuário 'jenkins' ao grupo sudo"
echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins
echo -e $GREEN "Usuário adicionado com sucesso."

echo -e $BLUE "Entrando como usuário 'jenkins'"

RED="\033[0;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34;49m"
COLOR_END="\033[m\n"

sudo su jenkins <<EOF

cd
wget https://www.opscode.com/chef/install.sh
chmod +x install.sh
sudo ./install.sh
chef-solo -v

cd
mkdir .chef
echo "cookbook_path [ '/var/lib/jenkins/chef-repo/cookbooks' ]" > .chef/knife.rb
git clone https://github.com/opscode/chef-repo.git
cd ~/chef-repo/cookbooks
knife cookbook site install apt
knife cookbook create noosfero

cd noosfero
echo "
name             'noosfero'
maintainer       'gcs'
description      'Installs/Configures noosfero'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt'" > metadata.rb

cd recipes

echo 'include_recipe "apt"

apt_repository "noosfero" do
  uri "http://download.noosfero.org/debian/wheezy ./"
end

%W{ ruby debhelper po4a ruby-gettext ruby-sqlite3 rake rails3 ruby-rspec ruby-rspec-rails ruby-will-paginate cucumber ruby-cucumber-rails ruby-capybara ruby-database-cleaner ruby-selenium-webdriver ruby-tidy ruby-mocha imagemagick xvfb tango-icon-theme rails3 ruby rake ruby-dalli ruby-exception-notification ruby-gettext ruby-fast-gettext ruby-pg ruby-rmagick ruby-redcloth ruby-will-paginate iso-codes ruby-feedparser ruby-daemons thin tango-icon-theme ruby-hpricot ruby-nokogiri ruby-acts-as-taggable-on ruby-progressbar ruby-prototype-rails ruby-rails-autolink ruby-memcache-client ruby-rest-client postgresql postgresql-client postfix jenkins memcached libpgsql-ruby }.each do |package|
  apt_package package do
    action :install
    options "-y --force-yes"
  end
end' > default.rb

cd ~/chef-repo

echo 'file_cache_path "/var/lib/jenkins/chef-solo"
cookbook_path "/var/lib/jenkins/chef-repo/cookbooks"' > solo.rb

echo '
{
  "run_list":[ "recipe[noosfero]" ] 
}' > web.json

cd ~/chef-repo
sudo chef-solo -c solo.rb -j web.json

sudo sed -i 's/peer/trust/g' /etc/postgresql/9.1/main/pg_hba.conf
sudo service postgresql restart
EOF
chmod +x gcs-config/teste-build.sh
cp gcs-config/teste-build.sh /var/lib/jenkins/
