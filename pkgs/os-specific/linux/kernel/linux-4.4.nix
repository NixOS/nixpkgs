{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.170";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04fia71k7hi9kmxmrqsdsi4nl6jw7vn1wkmdyh63hm89yz8dmy64";
  };
} // (args.argsOverride or {}))
