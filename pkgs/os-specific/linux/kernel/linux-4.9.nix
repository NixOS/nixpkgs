{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.243";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "111rlzx6z4kf8zwxncib96d9wy6qmkbs0cq3dhnybipwlyf1iank";
  };
} // (args.argsOverride or {}))
