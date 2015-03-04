{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0-rc2";
  modDirVersion = "4.0.0-rc2";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "1njjl31g27ddjdp5z14fhx4mpm69jqkxy43k7liisvxdc9j75jj9";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
