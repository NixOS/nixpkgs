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
    version = "3.2.3";
    sha256Hash = "185p1vjcsyzpcdkrcyw06zpapv4jc43qw9i8a4amzpgk1rsgg19d";
  };
}
