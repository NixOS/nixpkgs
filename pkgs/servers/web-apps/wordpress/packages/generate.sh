#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p wp4nix jq
=======
#! nix-shell -I nixpkgs=../../../../.. -i bash -p wp4nix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

set -e
set -u
set -o pipefail
set -x

<<<<<<< HEAD
cd $(dirname "$0")

nixFlags="--option experimental-features nix-command eval --raw --impure --expr"
export NIX_PATH=nixpkgs=../../../../..
=======
nixFlags="--option experimental-features nix-command eval --raw --impure --expr"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
export WP_VERSION=$(nix $nixFlags '(import <nixpkgs> {}).wordpress.version')

PLUGINS=`cat wordpress-plugins.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`
THEMES=`cat wordpress-themes.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`
LANGUAGES=`cat wordpress-languages.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`

wp4nix -p $PLUGINS -pl en
wp4nix -t $THEMES -tl en
wp4nix -l $LANGUAGES

rm *.log themeLanguages.json pluginLanguages.json
