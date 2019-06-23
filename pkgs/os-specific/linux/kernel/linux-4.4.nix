{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.183";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "10ic3ldn3p95y0qrl91j5kjqjp18k30xvpgw7mmc1g7lgi2r8j2h";
  };
} // (args.argsOverride or {}))
