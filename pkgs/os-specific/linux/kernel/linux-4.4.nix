{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.104";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0bhc4ay8ikvhqxj191mbm5kshh2zj46n5snwfa1d6bqzdkgg5s5h";
  };
} // (args.argsOverride or {}))
