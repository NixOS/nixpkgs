{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.4";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "1a6vkn8rh5lgalxh6cwr4894n3yp7f2qxcbcjv42nnmy5g4fy5fd";
  };
})
