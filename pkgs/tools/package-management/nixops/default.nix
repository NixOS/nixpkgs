{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.5.1";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "0pba9c8ya4hvqmg458p74g69hb06lh0f5bsgw7dsi8pjrcb0624g";
  };
})
