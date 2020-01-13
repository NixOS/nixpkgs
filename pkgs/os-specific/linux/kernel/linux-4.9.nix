{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.209";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qarm90l1r4y68v5swhf81z6v6gspa8sw9jab3fxrz8mz6zdan02";
  };
} // (args.argsOverride or {}))
