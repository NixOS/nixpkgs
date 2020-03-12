{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.216";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0lgv5k8v5xz9z2z4k42566bh0akyk1gr0dx6s1m1rjrzsf9k86l6";
  };
} // (args.argsOverride or {}))
