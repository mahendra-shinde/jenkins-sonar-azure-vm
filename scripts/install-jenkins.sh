wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
apt update -y
apt install openjdk-8-jdk git maven docker.io unzip -y
apt install jenkins -y
systemctl enable jenkins
systemctl enable docker
usermod -aG docker jenkins
## Create the TOOLS directory 
## Create TOOLS directory for jenkins
mkdir /opt/tools/
## create the sonar.service configuration
cp sonar-service /etc/systemd/system/sonar.service
cd /opt/tools
## Install solar scanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
unzip sonar-scanner-cli-4.2.0.1873-linux.zip
mv sonar-scanner-4.2.0.1873-linux/ sonar/
rm sonar-scanner-cli-4.2.0.1873-linux.zip
## Change OWNER of tools to "jenkins"
chown -R jenkins:jenkins /opt/tools/
### SONARQUBE SETUP
# Update kernel memory page limits and max files limits (MANDATORY FOR SONARQUBE)
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
# Download SonarQube 7.1 (Compatible with JDK 8)
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.1.zip
unzip sonarqube-7.1.zip 
groupadd sonar
sudo useradd -c "user to run SonarQube" -d /opt/tools/sonarqube-7.1 -g sonar sonar 
cd sonarqube-7.1/bin/linux-x86-64
# set RUN_AS_USER=sonar
sed -i 's/#RUN_AS_USER=/RUN_AS_USER=sonar/g' sonar.sh
systemctl enable sonar
