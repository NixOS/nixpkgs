{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.248";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1kzczy0lz3lnjkhvx90dgjmzn3d3y55qxlihiclkr4y9c602d1s6";
  };
} // (args.argsOverride or {}))
