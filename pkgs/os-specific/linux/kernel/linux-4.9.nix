{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.184";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1bwzmmpc7k9n7p2s383pipdjc3hvqfbbacaxk7gdw9856pai8c83";
  };
} // (args.argsOverride or {}))
