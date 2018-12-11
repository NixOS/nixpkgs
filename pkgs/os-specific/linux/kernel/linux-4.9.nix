{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.144";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0avqc9v22jxf9p71279ssa1lhml3hf2zdkc4j0pzms929m1pzl85";
  };
} // (args.argsOverride or {}))
