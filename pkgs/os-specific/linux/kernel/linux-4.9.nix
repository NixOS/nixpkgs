{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.140";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0hzrha3rh90jwxjmrh4npd0q56pf512nmb8i2p484k9cikssx27q";
  };
} // (args.argsOverride or {}))
