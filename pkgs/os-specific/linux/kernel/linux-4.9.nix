{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.91";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0clqndkj24a9752bc8x7cwdrdl38yarpvwx2yqkc98czxi9agjk0";
  };
} // (args.argsOverride or {}))
