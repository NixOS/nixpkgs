{ stdenv, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.11.7";
  revision = "a";
  sha256 = "0gvg0gnhl2hi0zw705zh1a8wrwm9831jmw5llr1miq6av7hgxw7n";
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
