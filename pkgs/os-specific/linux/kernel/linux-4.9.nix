{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.51";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "12mag09scyzi5a352y39y4b6rjh89qqca53hhmjc396q09hsdyl3";
  };
} // (args.argsOverride or {}))
