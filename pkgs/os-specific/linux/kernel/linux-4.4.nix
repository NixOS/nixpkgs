{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.120";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0y7li4vcvv04aqkrgl01i98pgwm9njzrb8y8wdvwaq9658vhfpx2";
  };
} // (args.argsOverride or {}))
