{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18-rc4";
  modDirVersion = "3.18.0-rc4";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "1ifdz4ss2ghaw8h89f5738fhgy8m7g92y763q8wrd9r4nipqdpnr";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
