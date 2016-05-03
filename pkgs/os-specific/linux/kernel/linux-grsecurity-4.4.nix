{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

throw "grsecurity stable is no longer supported; please update your configuration"

import ./generic.nix (args // rec {
  version = "4.4.5";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1daavrj2msl85aijh1izfm1cwf14c7mi75hldzidr1h2v629l89h";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
