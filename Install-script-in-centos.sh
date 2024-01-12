#Install script in centos 8

#!/bin/bash

# Log file to capture errors
error_log="/tmp/install_errors.log"

# Function to log errors
log_error() {
  local error_message="$1"
  echo "$error_message" >> "$error_log"
}

# Redirect all standard error to the error log file
exec 2>> "$error_log"

# Update the system
yes | yum update -y || log_error "Error updating the system."

# Install Nginx
yes | yum install nginx -y || log_error "Error installing Nginx."

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Install additional packages
yes | yum install tree net-tools firewalld -y || log_error "Error installing additional packages."
yes | sudo dnf install epel-release -y || log_error "Error installing EPEL repository."
yes | sudo dnf upgrade -y || log_error "Error upgrading the system."
yes | sudo yum install snapd -y || log_error "Error installing Snapd."

# Enable and configure Snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# Install Certbot via Snap
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Create directories for Nginx configuration
mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

# Start and enable Firewalld
systemctl start firewalld
systemctl enable firewalld

# Configure Firewalld rules
firewall-cmd --list-services
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# Allow Nginx to make network connections
setsebool -P httpd_can_network_connect 1

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Adjust repository configurations
dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos
dnf distro-sync

# Reload the Firewalld rules
firewall-cmd --reload

# Open UDP port 5173
sudo firewall-cmd --zone=public --add-port=5173/udp --permanent

# Check if any errors occurred and display them
if [ -s "$error_log" ]; then
  echo "Installation completed with errors. Check $error_log for details."
else
  echo "Installation and configuration completed successfully."
fi



