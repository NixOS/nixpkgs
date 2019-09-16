{ callPackage }:

let
  mkScons = args: callPackage (import ./common.nix args) { };
in {
  scons_3_0_1 = mkScons {
    version = "3.0.1";
    sha256 = "0wzid419mlwqw9llrg8gsx4nkzhqy16m4m40r0xnh6cwscw5wir4";
  };
  scons_latest = mkScons {
    version = "3.1.1";
    sha256 = "19a3j6x7xkmr2srk2yzxx3wv003h9cxx08vr81ps76blvmzl3sjc";
  };
}
