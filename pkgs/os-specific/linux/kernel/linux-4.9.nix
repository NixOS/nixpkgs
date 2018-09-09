{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.126";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1davk0c760if20h3f9r18lcvb7lqzlx0chxlph7ld5nlaz3ncskd";
  };
} // (args.argsOverride or {}))
