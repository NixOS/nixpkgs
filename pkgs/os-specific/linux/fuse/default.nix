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
    version = "3.2.4";
    sha256Hash = "1ybgd4s7naiyvaris7j6fzp604cgi5mgrn715x8l4kn5k9d840im";
  };
}
