{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.115";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0fddhw9v5l8k2j31zlfikd2g397ngyynfbwg92z17vp510fxjf20";
  };
} // (args.argsOverride or {}))
