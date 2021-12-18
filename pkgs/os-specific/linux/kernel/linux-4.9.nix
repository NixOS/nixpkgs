{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.293";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0l64rz6ly5ls23lqq0cv98xb4z2mimp2jrsjrs6kq3zm4k2mm4gs";
  };
} // (args.argsOverride or {}))
