{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.66";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0fwnmba25ww5q4asfz3mqdmbrhfdfgid388701h4xy20pwpjndsy";
  };
} // (args.argsOverride or {}))
