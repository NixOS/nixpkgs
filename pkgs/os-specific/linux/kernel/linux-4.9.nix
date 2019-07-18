{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.185";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "16z3ijfzffpkp4mj42j3j8zbnpba1a67kd5cdqwb28spf32a66vc";
  };
} // (args.argsOverride or {}))
