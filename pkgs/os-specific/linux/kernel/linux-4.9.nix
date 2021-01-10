{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.250";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15vizxd2i2311skjank406ny3bc30c5rz2p9jvh5xz1yv12vzgcy";
  };
} // (args.argsOverride or {}))
