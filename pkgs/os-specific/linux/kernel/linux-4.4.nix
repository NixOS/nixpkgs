{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.297";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "116346nkbhaz8jc1118gh40y6pw1kq7c7hm74f8bjga1p0gjqn0c";
  };
} // (args.argsOverride or {}))
