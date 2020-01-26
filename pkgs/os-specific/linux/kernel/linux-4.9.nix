{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.211";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gmi27ih5ys1wxbrnc4a5dr9vw9ngccs9xpa2p0gsk4pbn6n15r5";
  };
} // (args.argsOverride or {}))
