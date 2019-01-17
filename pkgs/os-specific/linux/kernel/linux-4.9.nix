{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.151";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0p22xla6yq1zwhypfh1zkp0n12wjz5m806lmv8scwkbyh2amb5hm";
  };
} // (args.argsOverride or {}))
