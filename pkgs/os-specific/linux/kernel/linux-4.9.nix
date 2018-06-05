{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.106";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0g5y3ckwb1zn8gzsk1sc6vnmsrvsx5g2a1p0p9hrmsl8jnr9nh1d";
  };
} // (args.argsOverride or {}))
