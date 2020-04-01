{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.217";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "06b8av9f9pk2yp95nzv4322k0d5wsg40sxd9kfim1xzb093abckg";
  };
} // (args.argsOverride or {}))
