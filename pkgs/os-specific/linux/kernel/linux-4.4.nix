{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.192";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0fwak1hrahcky1hdk4h8693rjpx65c2sqzfm1x71nhhysa6r3fig";
  };
} // (args.argsOverride or {}))
