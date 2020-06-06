{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.226";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dwvm81i62b06jsl38spfn719zrsbwq5z8viwckrpw4ma4w9k0j1";
  };
} // (args.argsOverride or {}))
