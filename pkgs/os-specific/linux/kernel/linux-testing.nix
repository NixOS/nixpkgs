{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9-rc2";
  modDirVersion = "4.9.0-rc2";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "1hf913mgyz5niy971c505s8yhqrdvq65psdrjz7cxmdxsb96pk94";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
