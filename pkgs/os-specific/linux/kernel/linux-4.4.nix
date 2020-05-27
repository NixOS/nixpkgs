{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.224";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1lb8ypn558vk73bj4a20wq40cig9vmzjn2xzzdws78gfair6hxpg";
  };
} // (args.argsOverride or {}))
