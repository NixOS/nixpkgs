{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.154";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1j00y6hgj4c82y3j0gaqj68kf46fwxz1y5wx6ry5sgxnr3xp12z0";
  };
} // (args.argsOverride or {}))
