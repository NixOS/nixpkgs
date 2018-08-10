{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.119";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0d8bwsma9j7dhgymcfbchr8k3503w5vp3p18mfqv81x6l40pzqa9";
  };
} // (args.argsOverride or {}))
