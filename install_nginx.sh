#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=================================================="
echo " Starting Nginx Installation on Ubuntu "
echo "=================================================="

# 1. Update the system package manager lists
echo "--> Updating package lists..."
sudo apt update -y

# 2. Install Nginx
echo "--> Installing Nginx..."
sudo apt install nginx -y

# 3. Configure UFW Firewall to allow Nginx traffic (Port 80 and 443)
if command -v ufw >/dev/null; then
    echo "--> Configuring UFW firewall for Nginx..."
    sudo ufw allow 'Nginx Full'
else
    echo "--> UFW is not installed, skipping firewall rule generation."
fi

# 4. Start and enable Nginx service to run on boot
echo "--> Managing Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

# 5. Verification
echo "=================================================="
echo " Nginx Installation Completed Successfully! "
echo "=================================================="
echo "Checking service status:"
sudo systemctl is-active nginx

echo ""
echo "You can now access your server at: http://localhost"
echo "Main configuration path: /etc/nginx/nginx.conf"
echo "Default web root path: /var/www/html/"
echo "=================================================="

echo "<h1> Terraform In One Shot by TWS </h1>" | sudo tee /var/www/html/index.html