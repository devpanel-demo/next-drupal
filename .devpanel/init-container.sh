#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (C) 2025 DevPanel
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation version 3 of the
# License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# For GNU Affero General Public License see <https://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------

bash $APP_ROOT/.devpanel/re-config.sh
bash $APP_ROOT/.devpanel/custom_package_installer.sh

if [[ -n "$DB_SYNC_VOL" ]]; then
  if [[ ! -f "/var/www/build/.devpanel/init-container.sh" ]]; then
    echo  'Sync volume...'
    sudo chown -R 1000:1000 /var/www/build 
    rsync -av --delete --delete-excluded $APP_ROOT/ /var/www/build
  fi
fi