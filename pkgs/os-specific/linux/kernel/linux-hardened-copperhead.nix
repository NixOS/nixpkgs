{ stdenv, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.11.6";
  revision = "c";
  sha256 = "1n1j1y5g5fcvgpqjfq14fbg4cm32k420kbazipqbi84h9zwifa69";
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
