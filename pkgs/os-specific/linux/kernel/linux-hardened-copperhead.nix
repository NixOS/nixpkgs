{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.12.10";
  revision = "a";
  sha256 = "00vm7bc4sfj2qj3yar9hy6qf8m2kmkxmxlf8q908jb1m541pfvpn";
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
