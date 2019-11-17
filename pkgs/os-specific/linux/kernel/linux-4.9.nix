{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.202";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gsfbvsswpwj6r56ynb6mmx7dc8hp9yhi7sfr0hhii0gs4ffq241";
  };
} // (args.argsOverride or {}))
