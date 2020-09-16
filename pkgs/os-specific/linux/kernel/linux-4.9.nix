{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.236";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ma2z0nvby4qyxzi3vxa28f0wvlnl74njk6cryjrqaksq6161qp7";
  };
} // (args.argsOverride or {}))
