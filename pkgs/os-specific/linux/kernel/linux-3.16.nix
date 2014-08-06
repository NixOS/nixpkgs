{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.16";
  modDirVersion = "3.16.0";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "183p3pz2rfprbp5i4kwk90kjn90v40banwx8759jxnd74xwss4s8";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
