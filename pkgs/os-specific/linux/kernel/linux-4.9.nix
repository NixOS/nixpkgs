{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.164";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1rzqfcz3zlc86n7df1rmpgpdbk388vbcqm571q890lrsimsrixdd";
  };
} // (args.argsOverride or {}))
