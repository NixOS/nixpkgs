{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.12";
  revision = "a";
  sha256 = "1vh104y40b7lkmgdbr0rd56i6qydinijfnnzn5aj5fi4n0n750v6";
in

import ./generic.nix (args // {
  version = "${version}-${revision}";
  extraMeta.branch = "4.12";
  modDirVersion = "${version}.0";

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
