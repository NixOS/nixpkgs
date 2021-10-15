#!/usr/bin/env bash

set -euo pipefail

. "$stdenv/setup"

cp -r "$src" ekam
chmod -R u+w ekam
cd ekam
mkdir -p deps

# A single capnproto test file expects to be able to write to
# /var/tmp.  We change it to use /tmp because /var is not available
# under nix-build.
cp -r "$capnprotoSrc" deps/capnproto
chmod -R u+w deps/capnproto/c++/src/kj
substituteInPlace deps/capnproto/c++/src/kj/filesystem-disk-test.c++ \
  --replace "/var/tmp" "/tmp"

# NIX_ENFORCE_PURITY prevents ld from linking against anything outside
# of the nix store -- but ekam builds capnp locally and links against it,
# so that causes the build to fail. So, we turn this off.
#
# See: https://nixos.wiki/wiki/Development_environment_with_nix-shell#Troubleshooting
unset NIX_ENFORCE_PURITY

make
mkdir $out
cp -r bin $out

# Remove capnproto tools; there's a separate nix package for that.
rm $out/bin/capnp*
# Don't distribute ekam-bootstrap, which is not needed outside this build.
rm $out/bin/ekam-bootstrap
