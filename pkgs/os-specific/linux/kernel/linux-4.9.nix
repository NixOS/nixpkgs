{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.118";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0myx79rmxgjbr87r815vybmbg6iqgd3nycildrpwsh301kj8kxvx";
  };
} // (args.argsOverride or {}))
