{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

throw "grsecurity is unsupported on this release"

import ./generic.nix (args // rec {
  version = "4.5.6";
  extraMeta.branch = "4.5";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1bdyviimgnc4zbgd9v1xk87sj9h8cprjykifriddwslqxyr2yh0y";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
