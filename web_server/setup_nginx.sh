#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# Create the HTML file with the required content
sudo bash -c 'echo "<html><body><h1>Holberton School</h1></body></html>" > /var/www/html/index.html'

# Configure Nginx to serve the correct page
NGINX_CONF="/etc/nginx/sites-available/default"

sudo bash -c "cat > $NGINX_CONF" <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name carine03.tech www.carine03.tech;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Restart Nginx to apply the changes
sudo systemctl restart nginx

# Output a message indicating that the setup is complete
echo "Nginx has been configured and is serving the 'Holberton School' page."

# Verify if the setup is working as expected
response=$(curl -o /dev/null -s -w "%{http_code}\n" http://localhost)
expected="200"

if [ "$response" -eq "$expected" ]; then
    echo "Configuration successful. Nginx is serving the correct page."
else
    echo "Configuration failed. Expected HTTP status code $expected but got $response."
fi
