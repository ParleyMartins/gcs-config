cd ~/chef-repo
sudo chef-solo -c solo.rb -j web.json


cd ~/workspace/noosfero
sed -i '/NOOSFERO_DIR=\/var\/lib\/noosfero\/current/c\NOOSFERO_DIR=/var/lib/jenkins/workspace/noosfero ' ./etc/init.d/noosfero
sed -i '/NOOSFERO_USER=noosfero/c\NOOSFERO_USER=jenkins' ./etc/init.d/noosfero
sudo ./etc/init.d/noosfero setup


sudo bundle --local

echo "production:
  adapter: postgresql
  encoding: unicode
  database: noosfero_production
  username: jenkins

test:
  adapter: postgresql
  encoding: unicode
  database: noosfero_test
  username: jenkins" > config/database.yml

export RAILS_ENV=test
rake db:schema:load
rake noosfero:translations:compile >/dev/null 2>&1
rake db:migrate
rake db:test:prepare
rake db:drop

export RAILS_ENV=prodution
rake db:schema:load
rake noosfero:translations:compile >/dev/null 2>&1
rake db:migrate

rails c <<EOF
Environment.create!(:name => "My environment", :is_default => true)
Environment.default.domains << Domain.new(:name => 'your.domain.com')
admin = User.create(:login => 'adminuser', :email => 'admin@example.com', :password => 'admin', :password_confirmation => 'admin', :environment => Environment.default, :activated_at => Time.new)
admin.activate
Environment.default.add_admin admin.person
exit
EOF

rake db:drop
