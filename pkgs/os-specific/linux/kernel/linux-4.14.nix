{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

import ./generic.nix (args // rec {
  version = "4.14.16";

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "095c2cjmjfsgnmml4f3lzc0pbhjy8nv8w07rywgpp5s5494dn2q7";
  };
} // (args.argsOverride or {}))
