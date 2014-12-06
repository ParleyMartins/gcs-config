./script/quick-start
rake

thin -C config/thin.yml -e $WORKSPACE config

sed -i "/NOOSFERO_DIR=\/var\/lib\/noosfero\/current/c\NOOSFERO_DIR=$WORKSPACE/noosfero " ./etc/init.d/noosfero
sed -i '/NOOSFERO_USER=noosfero/c\NOOSFERO_USER=jenkins' ./etc/init.d/noosfero
sudo ./etc/init.d/noosfero setup

export RAILS_ENV=prodution
rake db:create
rake db:schema:load
rake noosfero:translations:compile >/dev/null 2>&1
rails c <<EOF
Environment.create!(:name => 'Noosfero', :contact_email => 'noosfero@localhost.localdomain', :is_default => true)
Environment.default.domains << Domain.new(:name => 104.131.171.49)
user = User.create(:login => 'adminuser', :email => 'admin@example.com', :password => 'admin', :password_confirmation => 'admin', :environment => Environment.default, :activated_at => Time.new)
user.activate
EOF
./script/production start
./script/production stop
