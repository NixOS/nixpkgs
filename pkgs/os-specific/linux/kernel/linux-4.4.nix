{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.174";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0fdsxfwhn1xqic56c4aafxw1rdqy7s4w0inmkhcnh98lj3fi2lmy";
  };
} // (args.argsOverride or {}))
