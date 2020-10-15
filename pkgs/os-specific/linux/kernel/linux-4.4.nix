{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.239";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "03myd9ngmjmnddh4iqqsgcfg9rd11vyvwym38yh4m1p08j1zbg0k";
  };
} // (args.argsOverride or {}))
