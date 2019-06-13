{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.181";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1lw1qsql9dv8dllz6hglahxdfgzg34rpl9c9gwdrpm4j660nkaxj";
  };
} // (args.argsOverride or {}))
