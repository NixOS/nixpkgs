{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.128";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04kgdci8xndml2fwbam59pjwwxqd4kf7y3qgkk4asshs9546zdxx";
  };
} // (args.argsOverride or {}))
