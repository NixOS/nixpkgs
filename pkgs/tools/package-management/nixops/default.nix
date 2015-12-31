{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.3";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops/nixops-${version}.tar.bz2";
    sha256 = "d80b0fe3bb31bb84a8545f9ea804ec8137172c8df44f03326ed7639e5a4bad55";
  };
})
