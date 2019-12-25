{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.207";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "090181vij95py22jhx7baaxabb78w0j5hsfsnzp6bv2vgdz671na";
  };
} // (args.argsOverride or {}))
