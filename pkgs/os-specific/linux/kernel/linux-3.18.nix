{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18";
  modDirVersion = "3.18.0";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1gcc33mnjay3wr61y0613hfvq99pbkb6dkm3ab6gbmz6r4y43k5y";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
