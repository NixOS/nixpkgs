{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.6.1pre2728_8ed39f9";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/88329589/download/2/nixops-${version}.tar.bz2";
    sha256 = "1ppnhqmsbiijm6r77h86abv3fjny5iq35yvj207s520kjwzaj7kc";
  };
})
