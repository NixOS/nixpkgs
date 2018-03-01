{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.85";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1hb5v5ycgg5wbv28s8vxw804blfshpf82chrwspdbl2vwkp17zl0";
  };
} // (args.argsOverride or {}))
