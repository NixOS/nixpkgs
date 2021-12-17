{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.295";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1h3i2lgm2sy325f58jildip7m6sb4hr2n9pm3gc3h2gash65kc2r";
  };
} // (args.argsOverride or {}))
