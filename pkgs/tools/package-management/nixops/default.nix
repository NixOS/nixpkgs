{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.6.1";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "0lfx5fhyg3z6725ydsk0ibg5qqzp5s0x9nbdww02k8s307axiah3";
  };
})
