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
    version = "3.2.0";
    sha256Hash = "0bfpwkfamg4rcbq1s7v5rblpisqq73z6d5j3dxypgqll07hfg51x";
    maintainers = [ maintainers.primeos ];
  };
}
