{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1-rc7";
  modDirVersion = "4.1.0-rc7";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "09bxkm0nl9vzlfb14500bl6zjzhgacy7y32b3mw1d9hx62yknk2f";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
