thin -C config/thin.yml -e $WORKSPACE config

sed -i "/NOOSFERO_DIR=\/var\/lib\/noosfero\/current/c\NOOSFERO_DIR=$WORKSPACE" ./etc/init.d/noosfero
sed -i '/NOOSFERO_USER=noosfero/c\NOOSFERO_USER=jenkins' ./etc/init.d/noosfero
sudo ./etc/init.d/noosfero setup

export RAILS_ENV=production
rake db:create
rake db:schema:load
rake noosfero:translations:compile >/dev/null 2>&1
rails c <<EOF
Environment.create!(:name => 'Noosfero', :contact_email => 'noosfero@localhost.localdomain', :is_default => true)
Environment.default.domains << Domain.new(:name => 'your.domain.com')
a = User.create!(:login => 'adminuser', :email => 'admin@example.com', :password => 'admin', :password_confirmation => 'admin', :environment => Environment.default)
a.activate
EOF

./script/production start
nmap -p 3000 localhost > a

sleep 5m
./script/production stop
rake db:drop
