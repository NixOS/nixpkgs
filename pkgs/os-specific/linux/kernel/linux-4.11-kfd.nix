{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  ver = "4.11.0";
  revision = "kfd-roc-1.6.x";
in
import ./generic.nix (args // rec {
  version = "${ver}-${revision}";
  modDirVersion = "${ver}";
  extraMeta.branch = "4.11";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCK-Kernel-Driver";
    # url = "https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver.git";
    rev = "roc-1.6.x";
    sha256 = "1gl883j1lzysvh4qnls75k72x2g4kzmx36rm5d6zfknk3mrk2b4d";
  };
} // (args.argsOverride or {}))
