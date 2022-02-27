{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.303";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1r8s28ckmg0av9716350hadn99q738k2slciw8pzxw1xq47hbsa5";
  };
} // (args.argsOverride or {}))
