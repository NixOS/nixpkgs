{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.216";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1hjgh9brvxzi6ypgfnk07l3j28xsxgz88sdshnz19vj96bn1w70q";
  };
} // (args.argsOverride or {}))
