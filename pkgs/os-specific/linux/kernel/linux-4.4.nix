{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.210";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pg754s3138d2lq5y2zd1z7dagdy8pl4ifmp0754sa1rkjd3h0ns";
  };
} // (args.argsOverride or {}))
