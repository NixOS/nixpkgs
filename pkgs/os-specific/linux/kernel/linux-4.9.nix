{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.206";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mnabj0d5ra40hijwynnzxnh5w1qnvkvj2l3ydsdhkdwm6cpiwhx";
  };
} // (args.argsOverride or {}))
