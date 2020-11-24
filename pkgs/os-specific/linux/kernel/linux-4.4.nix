{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.245";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0g1cnis8496kp1ln922gxa7skfr096mdvv89la6676yw7dd4lhyi";
  };
} // (args.argsOverride or {}))
