{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.188";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "08p2cfc9982b804vmkapfasgipf6969g625ih7z3062xn99rhlr7";
  };
} // (args.argsOverride or {}))
