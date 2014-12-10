IPS=$(hostname -I)
LOCAL_IP=($(echo ${IPS}))

wget http://$LOCAL_IP:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://$LOCAL_IP:8080/ install-plugin git
java -jar jenkins-cli.jar -s http://$LOCAL_IP:8080/ install-plugin gitlab-plugin
java -jar jenkins-cli.jar -s http://$LOCAL_IP:8080/ install-plugin rake -restart
java -jar jenkins-cli.jar -s http://$LOCAL_IP:8080/ create-job noosfero < ~/gcs-config/config.xml
java -jar jenkins-cli.jar -s http://$LOCAL_IP:8080/ build noosfero
sudo service jenkins restart

rm jenkins-cli.jar -fv 

sudo su jenkins <<EOF
cd ~/jobs/noosfero/workspace/
./script/quick-start
EOF
