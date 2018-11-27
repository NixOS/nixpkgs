{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.141";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "09mc5sxzzxmks20vslimaaaw0aamjcc3lvpyjydmr78s25q5zfsp";
  };
} // (args.argsOverride or {}))
