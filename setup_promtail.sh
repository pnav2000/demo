#!/bin/bash
 
# Install unzip if not already installed
echo "Checking if unzip is installed..."
if ! rpm -q unzip; then
  echo "unzip is not installed. Installing unzip..."
  sudo yum install -y unzip
else
  echo "unzip is already installed. Continuing..."
fi
 
# Download Promtail
echo "Downloading Promtail..."
wget https://github.com/grafana/loki/releases/download/v2.4.2/promtail-linux-amd64.zip
 
# Unzip the downloaded file
echo "Unzipping Promtail..."
unzip promtail-linux-amd64.zip
 
# Move Promtail binary to the appropriate location
echo "Moving Promtail to /usr/local/bin..."
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
 
# Create Promtail config file
echo "Creating Promtail config file..."
sudo tee /etc/promtail-local-config.yaml > /dev/null << EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0
 
positions:
  filename: /data/loki/positions.yaml
 
clients:
  - url: http://localhost:3100/loki/api/v1/push
 
scrape_configs:
- job_name: system
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/*log
EOF
 
# Create Promtail service file
echo "Creating Promtail service file..."
sudo tee /etc/systemd/system/promtail.service > /dev/null << EOF
[Unit]
Description=Promtail service
After=network.target
 
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/promtail -config.file /etc/promtail-local-config.yaml
 
[Install]
WantedBy=multi-user.target
EOF
 
# Reload system daemon
echo "Reloading system daemon..."
sudo systemctl daemon-reload
 
# Start Promtail service
echo "Starting Promtail service..."
sudo systemctl start promtail.service
 
# Check Promtail service status
echo "Checking Promtail service status..."
systemctl status promtail.service
