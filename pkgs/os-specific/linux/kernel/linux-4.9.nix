{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.137";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1295x8a8k8bdanrpsalnaaq00mk3fl91sr14061lrgwlj0m53ckd";
  };
} // (args.argsOverride or {}))
