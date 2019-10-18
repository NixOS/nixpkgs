{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.197";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "032as6g4xvqjarqhvx7mr14yhn6idak4g0ps1skmsl4dfav6hdam";
  };
} // (args.argsOverride or {}))
