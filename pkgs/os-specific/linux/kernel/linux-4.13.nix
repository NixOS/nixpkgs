{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.8";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "09zl4gpw9j4xn6p78s6ba6qjjxpsy8whhvn19wnjhr9w4al8rrk4";
  };
} // (args.argsOverride or {}))
