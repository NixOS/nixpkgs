{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.98";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gdpq4w6srz2fpyi8bqpgz0p5wm3mrk7ir967c6f2285mdvcb7r6";
  };
} // (args.argsOverride or {}))
