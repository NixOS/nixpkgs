{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.200";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1z7gf36mh022nihdg4dlkdscr01jvbwikkm6jsbwcvdbv0s5qq2b";
  };
} // (args.argsOverride or {}))
