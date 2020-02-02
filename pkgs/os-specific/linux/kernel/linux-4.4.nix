{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.212";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0mx3qyj6w6h7gw7drsfsgl4iyz1695sjnf9hqh4kczci48kw5rj7";
  };
} // (args.argsOverride or {}))
