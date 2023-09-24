#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

echo "______            _     _   _____ _           _       "
echo "| ___ \          (_)   | | /  __ \ |         (_)      "
echo "| |_/ /__ _ _ __  _  __| | | /  \/ |__   __ _ _ _ __  "
echo "|    // _\` | '_ \| |/ _\` | | |   | '_ \ / _\` | | '_ \ "
echo "| |\ \ (_| | |_) | | (_| | | \__/\ | | | (_| | | | | |"
echo "\_| \_\__,_| .__/|_|\__,_|  \____/_| |_|\__,_|_|_| |_|"
echo "           | |                                        "
echo "           |_|                                        "
sudo apt update && sudo apt upgrade -y
sudo apt install gcc make git -y
wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz
rm -rf go1.21.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
git clone https://github.com/RapidChainIO/mainnet.git
#rm -rf .rapidd
mkdir .rapidd
cd mainnet
cp -r data ../.rapidd/data
cp -r config ../.rapidd/config
git clone https://github.com/RapidChainIO/Rapid-Chain.git
cd Rapid-Chain
make install
cd $HOME/go/bin
mv evmosd rapidd
echo "[Unit]
Description=Rapidd Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$HOME/go/bin/rapidd start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/rapidd.service
sudo mv $HOME/rapidd.service /etc/systemd/system
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable rapidd
sudo systemctl restart rapidd
mv $HOME/go/bin/rapidd /usr/local/bin/
rapidd keys add wallet

if [ $? -eq 0 ]; then

  echo "************************************************"
  echo "**** Key created successfully. Please make sure to save and secure the key."
  echo "************************************************"

else
  echo "An error occurred while creating the key."
fi


