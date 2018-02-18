{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.82";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "105im51ax2cwfqkljfi1sqh6sap6sc76zh5l9n7fpbys04khnwab";
  };
} // (args.argsOverride or {}))
