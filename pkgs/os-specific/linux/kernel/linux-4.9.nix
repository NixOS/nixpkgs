{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.221";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gh1x73xblxkb927igc3shrqnn49lcscwrq2fixmk9n7jb7q2hp6";
  };
} // (args.argsOverride or {}))
