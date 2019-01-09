{ callPackage }:

let
  mkScons = args: callPackage (import ./common.nix args) { };
in {
  scons_2_5_1 = mkScons {
    version = "2.5.1";
    sha256 = "1wji1z9jdkhnmm99apx6fhld9cs52rr56aigniyrcsmlwy52298b";
  };
  scons_3_0_1 = mkScons {
    version = "3.0.1";
    sha256 = "0wzid419mlwqw9llrg8gsx4nkzhqy16m4m40r0xnh6cwscw5wir4";
  };
  scons_3_0_2 = mkScons {
    version = "3.0.2";
    sha256 = "00fyvb2rrixj9h6f2sqr6z8q677anc61qcn9ydxgm99f9j7wzbyh";
  };
}
