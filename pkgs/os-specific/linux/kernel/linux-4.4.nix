{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.249";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04pb4vgia6zaindf6804gq9jn3mhmy01yijqmpi79sh9rlqzzh1i";
  };
} // (args.argsOverride or {}))
