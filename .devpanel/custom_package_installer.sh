#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (C) 2023 DevPanel
# You can install any service here to support your project
# Please make sure you run apt update before install any packages
# Example:
# - sudo apt-get update
# - sudo apt-get install nano
#
# ----------------------------------------------------------------------

sudo cp -f $APP_ROOT/.devpanel/000-default.conf /etc/apache2/sites-enabled/000-default.conf
## Install NPM
if ! command -v npm >/dev/null 2>&1; then
  echo "NPM install"
  sudo apt-get update
  sudo apt-get install -y nano
  sudo a2enmod proxy
  sudo a2enmod proxy_http
  # Download and install Node.js and npm
  curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm install -g yarn
  sudo npm install -g pm2
fi

## Setup next environment
cd $APP_ROOT/next
if [[ ! -z "$DP_HOSTNAME" && ! -f "$APP_ROOT/next/.env" ]]; then
  echo "Setup next environment"
  cat << EOF > "$APP_ROOT/next/.env"
NEXT_PUBLIC_DRUPAL_BASE_URL=https://$DP_HOSTNAME/drupal/web
NEXT_PUBLIC_DRUPAL_BASE_IMAGE=https://$DP_HOSTNAME
NEXT_IMAGE_DOMAIN=$DP_HOSTNAME
DRUPAL_PREVIEW_SECRET=SECRET
NEXTAUTH_SECRET=SECRET
NEXTAUTH_URL=https://$DP_HOSTNAME
DRUPAL_CLIENT_ID=SECRET
DRUPAL_CLIENT_SECRET=SECRET
EOF
fi

cd $APP_ROOT/next
npm install
if [[ -f "$APP_ROOT/next/.env" ]]; then
  echo "PM2 start app"
  sudo chown -R www:www /home/www/.pm2/
  sudo chown -R www:www $APP_ROOT/next/.next
  pm2 start
  curl http://localhost:3000
fi