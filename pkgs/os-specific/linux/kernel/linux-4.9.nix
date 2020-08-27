{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.234";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qw26x2qc29yr094c7scw68m9yz4j0b2c4f92rvi3s31s928avvm";
  };
} // (args.argsOverride or {}))
