{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.103";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1n4kqa0yf5svg8jk647h4awz3ygq696yi0agnmbz0alxnynffsij";
  };
} // (args.argsOverride or {}))
