{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.113";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0gbpmx09jq2cryqnnv3z4d7971gkrvn7nndxz1diny9ain4x4wmp";
  };
} // (args.argsOverride or {}))
