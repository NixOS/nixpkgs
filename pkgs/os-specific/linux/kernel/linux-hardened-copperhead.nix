{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.12.5";
  revision = "a";
  sha256 = "03cyh9fsbd95gdd477k1jmk3f9aj5dnw5wr8041y51v8f63vzbpk";
in

import ./generic.nix (args // {
  version = "${version}-${revision}";
  extraMeta.branch = "4.12";
  modDirVersion = "${version}-hardened";

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
