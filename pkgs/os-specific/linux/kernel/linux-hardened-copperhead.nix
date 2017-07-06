{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.11.8";
  revision = "a";
  sha256 = "02wy5gpgl2hz06dlqcgg9i3ydnxkyw0m1350vc5xyh6ld5r7jnn5";
in

import ./generic.nix (args // {
  version = "${version}-${revision}";
  extraMeta.branch = "4.11";
  modDirVersion = version;

  src = fetchFromGitHub {
    inherit sha256;
    owner = "copperhead";
    repo = "linux-hardened";
    rev = "${version}.${revision}";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
