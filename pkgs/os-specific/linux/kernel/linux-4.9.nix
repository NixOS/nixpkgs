{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.94";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15rd1rmvwx6wyqp857bdl77ijd233svm5wxyjyj8dy8n36yivk39";
  };
} // (args.argsOverride or {}))
