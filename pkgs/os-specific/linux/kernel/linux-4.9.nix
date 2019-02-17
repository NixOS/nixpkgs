{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.158";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vvm2gw5cddy40amxxr1hcw0bis2zldzyicvjhy11wg6j3snk2lc";
  };
} // (args.argsOverride or {}))
