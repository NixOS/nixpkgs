{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.135";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1kjly5ynsg2jy5nj41z21s8f18wfs4nk843jlmmcazzax6xv08z0";
  };
} // (args.argsOverride or {}))
