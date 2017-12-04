{ stdenv, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.15-rc2";
  modDirVersion = "4.15.0-rc2";
  extraMeta.branch = "4.15";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1i79gkjipj1q7w0d4zjz2hj43r12jicgznxk0wz0la2d8a4d3lcq";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
