#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl bundix git libiconv libpcap libxml2 libxslt pkg-config postgresql ruby.devEnv sqlite xmlstarlet nix-update

set -eu -o pipefail
cd "$(dirname "$(readlink -f "$0")")"

latest=$(curl https://github.com/rapid7/metasploit-framework/tags.atom | xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m /atom:feed/atom:entry -v atom:title -n | head -n1)
echo "Updating metasploit to $latest"

sed -i "s#refs/tags/.*#refs/tags/$latest\"#" Gemfile

bundler install
bundix
sed -i '/[ ]*dependencies =/d' gemset.nix

cd "../../../../"
nix-update metasploit --version "$latest"
