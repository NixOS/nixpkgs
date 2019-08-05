{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.187";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1iyimwl4ysnk6m66m73sg0cnp4vac56d6yy174shfpnj5h2csjq1";
  };
} // (args.argsOverride or {}))
