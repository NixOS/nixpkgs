{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.269";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0qx5zwi2ijwv9jwhs4cz91z7yxy6nd0g8ryzrlg1ar2xyk8w4yh4";
  };
} // (args.argsOverride or {}))
