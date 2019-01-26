{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.152";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0fcff0v488x0rylscl061dj8ylriwxg6hlg8mzppxx4sq22ppr4h";
  };
} // (args.argsOverride or {}))
