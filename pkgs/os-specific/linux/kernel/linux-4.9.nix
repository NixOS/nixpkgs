{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.130";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0zqaidirnr3v9xibp04rr2cjww3nd3phg28cgid0s8q0idm3xnv0";
  };
} // (args.argsOverride or {}))
