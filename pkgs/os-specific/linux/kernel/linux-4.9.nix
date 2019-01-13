{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.150";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1r0pf44j523a142skgcy97ia32r46gg3ivzg1ziy8cxll9xigk4l";
  };
} // (args.argsOverride or {}))
