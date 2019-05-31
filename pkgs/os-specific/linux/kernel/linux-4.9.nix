{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.180";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0pvw71yiwwf19qxqkm68dw4c9sl54n367q9kfdc6msd3c86ljnnj";
  };
} // (args.argsOverride or {}))
