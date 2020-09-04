{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.235";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0w5pkv936zb0shjgnpv17gcp5n8f91djznzq54p6j1bl5q2qdyqd";
  };
} // (args.argsOverride or {}))
