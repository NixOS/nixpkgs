{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.191";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1g5p736p8zx5rmxaj56yw93jp768npl868jsn8973dny0rsbim6y";
  };
} // (args.argsOverride or {}))
