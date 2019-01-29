{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.153";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "06kksywm8yjvmhmwdkqmm6546j5nqprsal3k22p981smqag94rlh";
  };
} // (args.argsOverride or {}))
