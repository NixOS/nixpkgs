{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.175";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1r8bp8dcjgndx9ziwv3pkgngr1bxwvdmimg8gxq8ak0km9bqfz76";
  };
} // (args.argsOverride or {}))
