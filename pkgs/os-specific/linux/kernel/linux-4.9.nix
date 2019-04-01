{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.165";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0g045xvmal9px4acadjgbwih1bvphj9whrgk2y204dsbymm93827";
  };
} // (args.argsOverride or {}))
