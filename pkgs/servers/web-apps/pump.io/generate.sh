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

curl https://raw.githubusercontent.com/e14n/pump.io/v1.0.0/package.json | \
    jshon -e dependencies              \
          -s '*' -i databank-mongodb   \
          -s '*' -i databank-redis     \
          -s '*' -i databank-memcached \
          -s '*' -i databank-lrucache  \
          -p | sed 's=\\/=/=g' > full-package.json

node2nix --input full-package.json --composition composition.nix --node-env ../../../development/node-packages/node-env.nix

# overriding nodePackages src doesn't seem to work, so...
sed -i 's|src = ./.|src = fetchurl { url = "https://registry.npmjs.org/pump.io/-/pump.io-1.0.0.tgz"; sha1 = "404mzdqzknrv7pl9qasksi791cc00bbd"; }|' node-packages.nix
