{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.219";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mpxqb2m24ay4n9px4n2cyklxy4lhnv9q6wlvilx13rs5qfbb62f";
  };
} // (args.argsOverride or {}))
