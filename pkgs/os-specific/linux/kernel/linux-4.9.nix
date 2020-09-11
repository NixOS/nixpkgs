{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.235";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1hqcb3zw4546h6x5xy2mywdznha8813lx15mxbgfbvwm4qhsc9g6";
  };
} // (args.argsOverride or {}))
