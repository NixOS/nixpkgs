{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0-rc4";
  modDirVersion = "4.0.0-rc4";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "01jn3mpxd1gly79psgh27l9ad24i07z9an0mw93pbs16nnncv0dn";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
