{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.179";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qqy2ysd61gq9zlh1yg71354wn8rbp8hkz94j6nnv00305xlnbjk";
  };
} // (args.argsOverride or {}))
