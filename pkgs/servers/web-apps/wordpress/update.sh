#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq wp4nix

set -eu -o pipefail

version=$(curl --globoff "https://api.wordpress.org/core/version-check/1.7/" | jq -r '.offers[0].version')
update-source-version wordpress $version

# cd /tmp
# curl https://wordpress.org/latest.tar.gz | tar xzf -
# ls wordpress/wp-content/themes/  # update the command below with that
# ls wordpress/wp-content/plugins/ # update the command below with that

cd pkgs/servers/web-apps/wordpress/themes-and-plugins
WP_VERSION=5.8 WORKERS=1 wp4nix -t twentynineteen,twentytwenty,twentytwentyone -p akismet,hello-dolly
rm *.log languages.json pluginLanguages.json themeLanguages.json
cd ../../../../..
