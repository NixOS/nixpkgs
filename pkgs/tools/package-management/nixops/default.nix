{ callPackage, newScope, pkgs, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.7";
  src = fetchurl {
    url = "https://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "091c0b5bca57d4aa20be20e826ec161efe3aec9c788fbbcf3806a734a517f0f3";
  };
})
