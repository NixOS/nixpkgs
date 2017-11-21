{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.100";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0kyi3cplkd839alyd6vsw2cqkb523zfsrjb2d6ygcddxqjcwsdlr";
  };
} // (args.argsOverride or {}))
