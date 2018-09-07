{ callPackage }:

let
  mkScons = args: callPackage (import ./common.nix args) { };
in {
  scons_2_5_1 = mkScons {
    version = "2.5.1";
    sha256 = "1wji1z9jdkhnmm99apx6fhld9cs52rr56aigniyrcsmlwy52298b";
  };
  scons_3_0_0 = mkScons {
    version = "3.0.0";
    sha256 = "05jjykllk4icnq6gfrkgkbc4ggxm7983q6r33mrhpilqbd02ylqg";
  };
  scons_3_0_1 = mkScons {
    version = "3.0.1";
    sha256 = "0wzid419mlwqw9llrg8gsx4nkzhqy16m4m40r0xnh6cwscw5wir4";
  };
}
