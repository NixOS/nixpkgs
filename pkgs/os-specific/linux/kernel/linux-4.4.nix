{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.241";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "054jd6jgymxbkjfmk8wbckihl355gjimjg2xi5yr4v2343qi9zij";
  };
} // (args.argsOverride or {}))
