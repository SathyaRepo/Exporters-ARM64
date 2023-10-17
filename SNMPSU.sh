#!/bin/bash

# Update the package list
apt update

# Install necessary packages
apt install -y snmp snmpd

# Retrieve SNMP Exporter Files
echo "Retrieving SNMP Exporter Files"
wget https://github.com/prometheus/snmp_exporter/releases/download/v0.24.1/snmp_exporter-0.24.1.linux-arm64.tar.gz

# Unpack the SNMP Exporter archive
echo "Retrieved Package... Unpacking"
tar xvfz snmp_exporter-0.24.1.linux-arm64.tar.gz

sudo useradd --system prometheus

# Change to the SNMP Exporter directory
cd snmp_exporter-0.24.1.linux-arm64
cp ./snmp_exporter /usr/local/bin/snmp_exporter
cp ./snmp.yml /usr/local/bin/snmp.yml
cd /usr/local/bin/

# Copy the SNMP Exporter binary to /usr/sbin
#sudo cp snmp_exporter /usr/sbin/

# Create a systemd service file for SNMP Exporter
echo "Creating SNMP Exporter Service file"
sudo tee /etc/systemd/system/snmp-exporter.service <<EOF
[Unit]
Description=Prometheus SNMP Exporter Service
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/usr/local/bin/snmp_exporter --config.file="/usr/local/bin/snmp.yml"

[Install]
WantedBy=multi-user.target
EOF

# Save and exit from the text editor
sudo systemctl daemon-reload
sudo systemctl enable snmp_exporter
sudo systemctl start snmp_exporter
