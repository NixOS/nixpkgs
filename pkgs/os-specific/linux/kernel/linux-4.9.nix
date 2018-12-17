{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.146";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ncf7yqavxqkkwdrapy72hb7rsj67fm1rvd2hdy12p88wf5ml6aq";
  };
} // (args.argsOverride or {}))
