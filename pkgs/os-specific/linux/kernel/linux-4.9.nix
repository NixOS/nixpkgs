{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.89";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0a9l2gkyr1nhaak6vyjwgjn01ywpxwa8zp5fhw8rjnfk44bf2hql";
  };
} // (args.argsOverride or {}))
