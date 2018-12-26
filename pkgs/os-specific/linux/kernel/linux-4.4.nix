{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.169";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1aah2qmifj15kcck4m6p00zz0d80afs22bg44y3n4l926f0b1w86";
  };
} // (args.argsOverride or {}))
