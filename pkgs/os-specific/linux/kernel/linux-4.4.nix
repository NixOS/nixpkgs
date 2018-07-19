{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.141";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "08nbz4xg43v57h0x5zw69vnjkvddl9ppi0vwzwf6yxd3ism4p3ci";
  };
} // (args.argsOverride or {}))
