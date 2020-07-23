{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.231";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1c6p5hv18isa328pvpa3qmmsg4qsssf2mwsx3hzn489rb8ycdxp7";
  };
} // (args.argsOverride or {}))
