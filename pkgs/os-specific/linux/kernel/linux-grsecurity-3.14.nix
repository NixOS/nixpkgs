{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

throw "grsecurity stable is no longer supported; please update your configuration"

import ./generic.nix (args // rec {
  version = "3.14.51";
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1gqsd69cqijff4c4br4ydmcjl226d0yy6vrmgfvy16xiraavq1mk";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
