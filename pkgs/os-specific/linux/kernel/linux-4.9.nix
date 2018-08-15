{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.120";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14gx6gqahz74vaw8jd0wkxn0w05i7cyfgi24ld2q3p2yhq3gannp";
  };
} // (args.argsOverride or {}))
