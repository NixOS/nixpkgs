{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.256";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15qlv4m56dzv195xjy4yp8qsrkbmv51vwfg0qcm664hkrb4i32y4";
  };
} // (args.argsOverride or {}))
