{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.10";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0kmh0ybjh1l35pm421v2q3z9fyhss85agh1rkmnh9bim2bq1ac6h";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
