{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.226";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jj5ydz5cy87z7hrv54bkyl9739lpzja8580ngjhrip5iwb8q2j6";
  };
} // (args.argsOverride or {}))
