cd ~/chef-repo
sudo chef-solo -c solo.rb -j web.json

cd $WORKSPACE
rake

thin -C config/thin.yml -e $WORKSPACE config

sed -i "/NOOSFERO_DIR=\/var\/lib\/noosfero\/current/c\NOOSFERO_DIR=$WORKSPACE" ./etc/init.d/noosfero
sed -i '/NOOSFERO_USER=noosfero/c\NOOSFERO_USER=jenkins' ./etc/init.d/noosfero
sudo ./etc/init.d/noosfero setup

export RAILS_ENV=prodution
rake db:create
rake db:schema:load
rake noosfero:translations:compile >/dev/null 2>&1

./script/production start
./script/production stop
