{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.113";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0yxwsaxnz0k03b1zj1l95ls8qm2rra9hygnjzh9z60sax56myn63";
  };
} // (args.argsOverride or {}))
