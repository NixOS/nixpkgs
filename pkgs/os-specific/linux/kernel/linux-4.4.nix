{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.119";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1rj3hk31bx9nvpx0dmwiijyixiv0dcxvp2cx4fbkbs9fddxrn7sg";
  };
} // (args.argsOverride or {}))
