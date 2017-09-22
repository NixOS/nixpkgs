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
    version = "3.1.1";
    sha256Hash = "14mazl2i55fp4vjphwgcmk3mp2x3mhqwh9nci0rd0jl5lhpdmpq6";
    maintainers = [ maintainers.primeos ];
  };
}
