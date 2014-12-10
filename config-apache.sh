sudo a2enmod deflate expires proxy proxy_balancer proxy_http rewrite
sudo service apache2 restart

sudo cp  ~/gcs-config/noosfero /etc/apache2/sites-available/noosfero

sudo a2ensite noosfero
sudo service apache2 reload
sudo invoke-rc.d apache2 restart
