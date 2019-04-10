{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.178";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0g84g808v7zjnfm1nh7ba0swa4n2bfw8m7h5qgmknjwrnwi8qnf3";
  };
} // (args.argsOverride or {}))
