{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.6pre2276_9203440";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/64518294/download/2/nixops-${version}.tar.bz2";
    sha256 = "1cl0869nl67fr5xk0jl9cvqbmma7d4vz5xbg56jpl7casrr3i51x";
  };
})
