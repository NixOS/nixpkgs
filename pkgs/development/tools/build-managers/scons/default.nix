{ callPackage }:

let
  mkScons = args: callPackage (import ./common.nix args) { };
in {
  scons_3_0_1 = mkScons {
    version = "3.0.1";
    sha256 = "0wzid419mlwqw9llrg8gsx4nkzhqy16m4m40r0xnh6cwscw5wir4";
  };
  scons_3_0_3 = mkScons {
    version = "3.0.3";
    sha256 = "1wwn0534d83ryfxjihvqk2ncj8wh5210pi3jxjd2cvjqa9mpkv6q";
  };
}
