{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.6";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "0f8ql1a9maf9swl8q054b1haxqckdn78p2xgpwl7paxc98l67i7x";
  };
})
