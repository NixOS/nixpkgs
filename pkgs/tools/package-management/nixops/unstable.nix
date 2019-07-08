{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.7pre2764_932bf43";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/92372343/download/2/nixops-${version}.tar.bz2";
    sha256 = "f35bf81bf2805473ea54248d0ee92d163d00a1992f3f75d17e8cf430db1f9919";
  };
})
