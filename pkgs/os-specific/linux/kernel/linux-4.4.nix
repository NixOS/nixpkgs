{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.156";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1aj87ncc8afx4dr42rf2kr5ai2k5w5arcp8z336i2wlnrbcdhhh4";
  };
} // (args.argsOverride or {}))
