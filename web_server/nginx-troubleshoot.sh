#!/usr/bin/env bash
# Troubleshoot Nginx configuration issues

# Define the configuration file path
config_file="/etc/nginx/sites-available/default"
symlink_path="/etc/nginx/sites-enabled/default"

# Update package list and install Nginx
echo "Updating package list and installing Nginx..."
sudo apt update -y
sudo apt install nginx -y

# Check Nginx configuration syntax
echo "Checking Nginx configuration syntax..."
sudo nginx -t

# Check if the symbolic link exists
echo "Checking symbolic link in sites-enabled..."
if [ ! -L "$symlink_path" ]; then
    echo "Symbolic link not found. Creating symbolic link..."
    sudo ln -s "$config_file" "$symlink_path"
else
    echo "Symbolic link already exists."
fi

# Reload Nginx to apply new configuration
echo "Reloading Nginx..."
sudo systemctl reload nginx

# Check Nginx logs for errors
echo "Checking Nginx error logs..."
sudo tail -n 50 /var/log/nginx/error.log

# Verify file permissions
echo "Verifying file permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Test the redirection with curl
echo "Testing redirection for /redirect_me..."
curl -sI http://www.carineumugabe.tech/redirect_me

echo "Testing for non-existent path..."
curl -sI http://www.carineumugabe.tech/nonexistent

echo "Troubleshooting completed."
