{ stdenv, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.15-rc4";
  modDirVersion = "4.15.0-rc4";
  extraMeta.branch = "4.15";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "13mz21pdqk17hrwga9246cj9bkcz3xmmg0cb4mrbsrb1nv4niv0k";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
