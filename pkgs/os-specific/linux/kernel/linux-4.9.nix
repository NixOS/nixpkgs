{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.176";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0y5i0picww914ljynqjdpv7cld7380y9lrlgnza02zvkq04d151a";
  };
} // (args.argsOverride or {}))
