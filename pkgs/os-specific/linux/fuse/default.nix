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
    maintainers = [ ];
  };

  fuse_3 = mkFuse {
    version = "3.2.2";
    sha256Hash = "1a0x4vpyg9lc6clwvx995mk0v6jqd37xabzp9rpdir37x814g3wh";
    maintainers = [ maintainers.primeos ];
  };
}
