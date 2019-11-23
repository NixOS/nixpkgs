{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.201";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "120kci4kmc48zcw16lhxmh71kaxm9ac5qxik36q3a20czg28b2m7";
  };
} // (args.argsOverride or {}))
