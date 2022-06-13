apt-get update && apt-get -y install python
apt-get -y install python3-pip
apt-get -y install jq
sfdx --version
echo y | sfdx plugins:install sfdx-git-delta
pip3 install yq