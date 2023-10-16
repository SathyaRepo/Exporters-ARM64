#!/bin/bash

# Update the package list
apt update

# Retrieve Node Exporter Files
echo "Retrieving Node Exporter Files"
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-arm64.tar.gz

# Unpack the Node Exporter archive
echo "Retrieved Package... Unpacking"
tar xvfz node_exporter-1.6.1.linux-arm64.tar.gz

# Change to the Node Exporter directory
cd node_exporter-1.6.1.linux-arm64

# Copy the Node Exporter binary to /usr/sbin
sudo cp node_exporter-1.6.1.linux-arm64/node_exporter /usr/sbin/

# Create a systemd service file for Node Exporter
echo "Creating Service file"
sudo nano /etc/systemd/system/node_exporter.service

# Add the Node Exporter systemd service file configuration
echo "Creating Service file"
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
ExecStart=/usr/sbin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "Enabled Node-Exporter Service"
