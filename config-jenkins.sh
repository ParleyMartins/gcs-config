RED="\033[0;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34;49m"
COLOR_END="\033[m\n"

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install curl git jenkins

echo -e $BLUE "Adicionando usuário 'jenkins' ao grupo sudo"
echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins
echo -e $GREEN "Usuário adicionado com sucesso."
