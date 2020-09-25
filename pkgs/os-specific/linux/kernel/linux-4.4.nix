{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.237";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1q6hwjwvlsikgr8b04l7v2jia2wyqxgbli6i7y20aq49h13ap2qk";
  };
} // (args.argsOverride or {}))
