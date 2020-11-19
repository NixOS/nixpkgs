{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.244";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02givxp0y04qma5nlqbpyxdcl7xdb41p3gw7kgj2rmwdanhzaylr";
  };
} // (args.argsOverride or {}))
