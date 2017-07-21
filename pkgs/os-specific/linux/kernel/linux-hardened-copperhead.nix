{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.12.2";
  revision = "a";
  sha256 = "0w3k5a30li2qz2msach9sg9qsvmjsc4mf9k3ad5dxd0667a0hygm";
in

import ./generic.nix (args // {
  version = "${version}-${revision}";
  extraMeta.branch = "4.12";
  modDirVersion = "${version}";

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
