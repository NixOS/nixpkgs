{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.208";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0njjw1i8dilihn1hz62zra4b9y05fb3r2k2sqlkd0wfn86c1rbdp";
  };
} // (args.argsOverride or {}))
