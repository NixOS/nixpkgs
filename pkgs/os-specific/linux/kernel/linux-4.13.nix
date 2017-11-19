{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.14";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "10rjrh5yg6mdfg44xnyd5r4fc91c3b0hqf2yy7qzy7z1kr22lixs";
  };
} // (args.argsOverride or {}))
