{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.148";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "10yrqizwkawbs332rl3fmr3cpwcl2j0mik4md7isg5xlkc00zc8r";
  };
} // (args.argsOverride or {}))
