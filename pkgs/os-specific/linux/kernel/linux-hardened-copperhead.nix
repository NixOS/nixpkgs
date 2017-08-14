{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.12.7";
  revision = "a";
  sha256 = "1kj0s5r7fx2d0crak7576jv9r6q7yx4aqmxpib6mhj1zfhsczdp0";
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
