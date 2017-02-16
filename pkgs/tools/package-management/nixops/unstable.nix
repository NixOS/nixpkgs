{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.5";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "0z4pzc55wjab8v4bkrff94f8qp1g9ydgxxpl2dvy5130bg1s52wd";
  };
})
