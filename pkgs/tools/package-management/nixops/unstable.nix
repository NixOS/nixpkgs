{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.6.1pre2622_f10999a";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/73716350/download/2/nixops-${version}.tar.bz2";
    sha256 = "08886b6vxhjc3cp0ikxp920zap7wp6r92763fp785rvxrmb00rbd";
  };
})
