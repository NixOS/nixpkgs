{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.97";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "08vg8lm03s04cpyicq1jj342c25x3039nnxvcvwr80j18w4biwf4";
  };
} // (args.argsOverride or {}))
