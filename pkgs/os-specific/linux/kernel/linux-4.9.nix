{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.183";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1wv753a9z99nvvw881j6fxd6imk88xm3aq626gly5x6v3jcv0mzx";
  };
} // (args.argsOverride or {}))
