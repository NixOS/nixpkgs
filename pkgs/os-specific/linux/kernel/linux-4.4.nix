{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.236";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1v1mx16x1crnxf4pix0bhw40lq89n7wpd66gjc2mhxi75h6x6i80";
  };
} // (args.argsOverride or {}))
