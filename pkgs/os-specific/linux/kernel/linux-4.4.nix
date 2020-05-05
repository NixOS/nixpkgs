{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.222";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02zxy5vjxgrqs0mkz5aj70v6pazhif7x5cm26rf8zh4idpmhk2zh";
  };
} // (args.argsOverride or {}))
