{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.230";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qx74qli8yjc2rkb7kig79c1yv7pfqa8zi1wi0rndn4d4yk62cfa";
  };
} // (args.argsOverride or {}))
