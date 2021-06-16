{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.270";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1lz48gv1v3wvw9xvd3y9q4py7ii1g9fj4dwyvvjdzbipyw7s21pq";
  };
} // (args.argsOverride or {}))
