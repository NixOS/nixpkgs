{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.215";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0j4z2al318654z40w4f8zhh73zwpgn8igjr5k4mz401phm3jyvr3";
  };
} // (args.argsOverride or {}))
