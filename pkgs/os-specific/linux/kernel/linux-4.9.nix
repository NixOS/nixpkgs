{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.112";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pphyrqi20w8k9rg5mjkl0g3f2152c4gqzhgdi4hz8mad972kv30";
  };
} // (args.argsOverride or {}))
