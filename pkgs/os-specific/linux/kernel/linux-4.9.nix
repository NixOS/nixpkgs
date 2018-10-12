{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.132";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1lz53r6p293y5fwx7pz9ymj9sss3wmip8hcc48zwkcwm8phnmrk7";
  };
} // (args.argsOverride or {}))
