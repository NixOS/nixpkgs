{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14-rc4";
  modDirVersion = "4.14.0-rc4";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1n9jni7sdawhjnlpl1g3rw89ggfi8d6s088wv1h21cnmsav911ik";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
