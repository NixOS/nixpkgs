{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.218";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ka98c8sbfipzll6ss9fcsn26lh4cy60372yfw27pif4brhnwfnz";
  };
} // (args.argsOverride or {}))
