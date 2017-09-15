{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13-rc7";
  modDirVersion = "4.13.0-rc7";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1xkfxsvdhd0xcfjcr78222sa58i02z2ca9fv804jbyp7w9g628rm";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
