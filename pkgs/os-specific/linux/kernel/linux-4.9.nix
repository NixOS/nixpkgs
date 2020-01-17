{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.210";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04skcbbp1yv54hwipa1pjx04lb21013r0lh2swycq0kdhc1m54d0";
  };
} // (args.argsOverride or {}))
