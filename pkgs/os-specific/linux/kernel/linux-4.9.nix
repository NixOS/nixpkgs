{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.124";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04a3iqy6divkd9bamn60d0v8jkls2jbip7qn0m82dlcdikab19jw";
  };
} // (args.argsOverride or {}))
