{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.108";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ha0bvjfxz6nx3nrcrpciqlrphy318xi04lv4k7jr5hpialjpzkk";
  };
} // (args.argsOverride or {}))
