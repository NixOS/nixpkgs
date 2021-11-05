{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.291";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0lbbvv3ha4d8nwzjh8bdk0aqyd12w6gw0nsxsdnp8pbmnndgb9vh";
  };
} // (args.argsOverride or {}))
