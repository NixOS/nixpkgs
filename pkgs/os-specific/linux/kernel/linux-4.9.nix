{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.186";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0sjbp7m6d625rw06wv34a0805d1lgldii4pxiqfpja871m1q8914";
  };
} // (args.argsOverride or {}))
