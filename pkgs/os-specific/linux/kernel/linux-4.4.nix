{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.133";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0vhg23i49s4k8lbsrs8y6rvqjld84qgifmim5qcrndr6yj68fmk0";
  };
} // (args.argsOverride or {}))
