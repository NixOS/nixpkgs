{ stdenv, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.15-rc3";
  modDirVersion = "4.15.0-rc3";
  extraMeta.branch = "4.15";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1rbyh5phx6mfr3wrz3q33gj8bgw2r76hvbzhvq1ya7fw54jjnz98";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
