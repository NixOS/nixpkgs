{ stdenv, callPackage, utillinux }:

let
  mkFuse = args: callPackage (import ./common.nix args) {
    inherit utillinux;
  };
  maintainers = stdenv.lib.maintainers;
in {
  fuse_2 = mkFuse {
    version = "2.9.7";
    sha256Hash = "1wyjjfb7p4jrkk15zryzv33096a5fmsdyr2p4b00dd819wnly2n2";
    maintainers = [ maintainers.mornfall ];
  };

  fuse_3 = mkFuse {
    version = "3.2.1";
    sha256Hash = "19bsvb5lc8k1i0h5ld109kixn6mdshzvg3y7820k9mnw34kh09y0";
    maintainers = [ maintainers.primeos ];
  };
}
