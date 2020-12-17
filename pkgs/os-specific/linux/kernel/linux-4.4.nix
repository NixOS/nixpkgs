{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.248";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1z1xbkm0z0v6k3scszii5hi24pn391332g0li93p3n1rnv74jap5";
  };
} // (args.argsOverride or {}))
