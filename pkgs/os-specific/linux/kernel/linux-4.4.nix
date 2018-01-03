{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.109";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1i73xn85p6c62rafipmf9ja9ya149aaz6lbgnhl989fyyyh2bjd2";
  };
} // (args.argsOverride or {}))
