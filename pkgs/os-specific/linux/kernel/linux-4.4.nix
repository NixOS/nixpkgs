{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.223";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "09fln0sdfif2zv2jifp24yiqi0vcyj8fqx2jz91g21zvsxk3x5nd";
  };
} // (args.argsOverride or {}))
