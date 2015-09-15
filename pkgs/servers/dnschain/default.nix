{ stdenv, nodePackages }:

# to update dnschain, run npm2nix package.json package.nix, and
# then add "coffee-script" manually as a dependecy for "dnschain"
# in package.nix.

let
  np = nodePackages.override { generated = ./package.nix; self = np; };
in

np.dnschain
