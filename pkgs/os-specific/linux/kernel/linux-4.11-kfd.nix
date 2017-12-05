{ stdenv, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

let
  ver = "4.11.0";
  revision = "kfd-roc-1.6.x";
in
import ./generic.nix (args // rec {
  version = "${ver}-${revision}";
  extraMeta.branch = "4.11";

  src = fetchgit {
    url = "https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver.git";
    rev = "roc-1.6.x";
    sha256 = "0fwnmba25ww5q4asfz3mqdmbrhfdfgid388701h4xy20pwpjndsy";
  };
} // (args.argsOverride or {}))
