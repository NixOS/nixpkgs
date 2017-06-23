{ stdenv, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.11.6";
  revision = "d";
  sha256 = "1wpfvcbcs93gx8v87h2z7l2dzbyl9vlcqxpfz8y65achhjj7kqlg";
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
