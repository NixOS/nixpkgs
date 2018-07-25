{ stdenv, callPackage, utillinux }:

let
  mkFuse = args: callPackage (import ./common.nix args) {
    inherit utillinux;
  };
in {
  fuse_2 = mkFuse {
    version = "2.9.7";
    sha256Hash = "1wyjjfb7p4jrkk15zryzv33096a5fmsdyr2p4b00dd819wnly2n2";
  };

  fuse_3 = mkFuse {
    version = "3.2.5";
    sha256Hash = "0ibf2isbkm8p1gfaqpqblwsg0lm4s1rmcipv1qcg0wc4wwsbnqpx";
  };
}
