#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p nc4nix

set -e
set -u
set -o pipefail
set -x

export NEXTCLOUD_VERSIONS=$(nix-instantiate --eval -E 'import ./nc-versions.nix {}' -A e)

<<<<<<< HEAD
APPS=`cat nextcloud-apps.json | jq -r 'keys|.[]' | sed -z 's/\n/,/g;s/,$/\n/'`

nc4nix -apps $APPS
=======
APPS=`cat nextcloud-apps.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`

nc4nix -a $APPS
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
rm *.log
