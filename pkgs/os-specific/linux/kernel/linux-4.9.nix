{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.125";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jqi25ld83l57lzcbhrzdnmsj4isz686ivdj0wfsrgxyc7pxwr57";
  };
} // (args.argsOverride or {}))
