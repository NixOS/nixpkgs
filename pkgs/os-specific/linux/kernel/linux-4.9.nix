{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.58";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "19r1ybrfqjh2cmpvljd94cwag34kly7pzih2j5m4nr49hsi153vl";
  };
} // (args.argsOverride or {}))
