{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "2015-12-18";
  src = fetchurl {
    url = "http://hydra.nixos.org/build/29118371/download/2/nixops-1.3.1pre1673_a0d5681.tar.bz2";
    sha256 = "177lnlfz32crcc0gjmh1gn5y2xs142kmb4b68k4raxcxxw118kw9";
  };
})
