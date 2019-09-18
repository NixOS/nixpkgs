{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.7pre2844_b7cac11";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/99910702/download/2/nixops-${version}.tar.bz2";
    sha256 = "0fxvcbpf9xapl9qc4mcvmn18y1l4gsg43hcn88yzq0dmr5xw891f";
  };
})
