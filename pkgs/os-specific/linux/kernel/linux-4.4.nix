{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.217";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0vsjchywznmjn01flgvm9vsja5zqni319rfwgy997afcbz0c9spx";
  };
} // (args.argsOverride or {}))
