{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.222";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0aajgflf96bj7chbd83rdmgcdwd025c6mz6li4cwbfx7xcb91kjc";
  };
} // (args.argsOverride or {}))
