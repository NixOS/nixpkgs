{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.238";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0r1kb7p0zf0nkavvf9nr9hs7bdjym43cqv87hkp7vrqpbh1i8y06";
  };
} // (args.argsOverride or {}))
