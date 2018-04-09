{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.127";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gscsvijik24p0skhjnhqxlvzj3kfy5cmn3x9wn6ka687hwjb3qa";
  };
} // (args.argsOverride or {}))
