{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

with stdenv.lib;

let
  version = "4.9.40";
  sha256 = "1rv345hciwc1mjz6r8wx8f0fqd4mkc84q36nna7xq1rlgml8m933";
in

import ./generic.nix (args // {
  inherit version;

  extraMeta.branch = intersperse "." (take 2 (splitString "." version));
  modDirVersion = "${version}-unofficial+grsec";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "minipli";
    repo = "linux-unofficial_grsec";
    rev = "v${version}-unofficial_grsec";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
  features.grsecurity = true;
} // (args.argsOverride or {}))
