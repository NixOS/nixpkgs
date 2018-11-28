{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.6.1pre2706_d5ad09c";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/84098258/download/2/nixops-${version}.tar.bz2";
    sha256 = "0lr963a0bjrblv0d1nfl4d0p76jkq6l9xj3vxgzg38q0ld5qw345";
  };
})
