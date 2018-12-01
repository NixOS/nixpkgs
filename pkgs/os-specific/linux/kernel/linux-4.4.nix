{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.166";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0nj1wvsf1c843hp9ww68gpwsjdviax67dpffafsq78ask7yyy45z";
  };
} // (args.argsOverride or {}))
