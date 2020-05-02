{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.221";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "06rpjnvrdp71flz948mfmx7jv8x2vmdg54zz1xpkb2458mwh5hbq";
  };
} // (args.argsOverride or {}))
