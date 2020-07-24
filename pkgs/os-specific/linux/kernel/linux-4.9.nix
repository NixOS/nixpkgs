{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.231";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1sz8xk767yy4lxqvy4229yrgkwnm43hdrbr54aa1flns5yh3p12g";
  };
} // (args.argsOverride or {}))
