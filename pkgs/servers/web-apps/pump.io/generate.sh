#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix curl jshon

set -e

# Normally, this node2nix invocation would be sufficient:
#   exec node2nix --input node-packages.json --composition composition.nix
#
# But pump.io soft-depends on extra modules, which have to be *inside*
# its own node_modules, not beside them.
#
# So we hack these extra deps into package.json and feed that into
# node2nix.
#
# Also jshon does funny things with slashes in strings, which can be
# fixed with sed.

VERSION="3.0.0"
URL="https://registry.npmjs.org/pump.io/-/pump.io-$VERSION.tgz"
SHA1="ycfm7ak83xi8mgafhp9q0n6n3kzmdz16"

curl https://raw.githubusercontent.com/e14n/pump.io/v$VERSION/package.json | \
    jshon -e dependencies              \
          -s '*' -i databank-mongodb   \
          -s '*' -i databank-redis     \
          -s '*' -i databank-lrucache  \
          -p | sed 's=\\/=/=g' > full-package.json

node2nix --input full-package.json --composition composition.nix --node-env ../../../development/node-packages/node-env.nix

# overriding nodePackages src doesn't seem to work, so...
sed -i "s|src = ./.|src = fetchurl { url = \"$URL\"; sha1 = \"$SHA1\"; }|" node-packages.nix

# fetchgit or node2nix is having problems with submodules or something.
# This is the sha256 for connect-auth which is a npm dep hosted on
# github and containing submodules.
sed -i "s|d08fecbb72aff14ecb39dc310e8965ba92228f0c0def41fbde3db5ea7a1aac19|1b052xpj10hanx21286i5w0jrwxxkiwbdzpdngg9s2j1m7a9543b|" node-packages.nix
