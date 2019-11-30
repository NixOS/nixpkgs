{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.203";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02krniihix9mb9bc0ffs03q4i9grjhwymnfp10h1r6gmxa554qlj";
  };
} // (args.argsOverride or {}))
