{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.77";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0p3hnfj0597vznvvjcb4ynciafnmvmnphkk6izcj67kgp4zvqabw";
  };
} // (args.argsOverride or {}))
