#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive within the sudo command
sudo DEBIAN_FRONTEND=noninteractive apt -yq update

# Perform upgrade without user interaction
sudo DEBIAN_FRONTEND=noninteractive apt -yq upgrade

# Install necessary packages
sudo apt install -y git 

# Make sure you're in your home directory
cd $HOME

# Clone the Juneo-go binaries repository
git clone https://github.com/Juneo-io/juneogo-binaries.git

# Create directories and copy the juneogo binary
mkdir -p ~/.juneogo/plugins
cp juneogo-binaries/juneogo /usr/local/bin
chmod +x /usr/local/bin/juneogo
cp juneogo-binaries/plugins/jevm ~/.juneogo/plugins
chmod +x ~/.juneogo/plugins/jevm

# Create a service unit for juneogo
cat <<EOF | sudo tee /etc/systemd/system/juneogo.service > /dev/null
[Unit]
Description=Juneo-go Service

[Service]
ExecStart=/usr/local/bin/juneogo
Restart=always
User=$USER

[Install]
WantedBy=default.target
EOF

# Reload systemd to pick up the new service unit
sudo systemctl daemon-reload

# Enable and start the juneogo service
sudo systemctl enable juneogo.service

# Start the service 
sudo systemctl start juneogo.service

# Restart journactl 
sudo systemctl restart systemd-journald

# To check the current status of the 'juneogo' service, use the following command:
echo "To check the service status:"
echo "sudo systemctl status juneogo.service"

# If you need to view real-time logs for the running 'juneogo' service, use this command:
echo "To view live logs:"
echo "sudo journalctl -fu juneogo"
