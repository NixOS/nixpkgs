{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14-rc6";
  modDirVersion = "4.14.0-rc6";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0gmxrf4jmw8xl5gx487chyx94yas7rva5jbkczm9iw9sw0c8gwcb";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
