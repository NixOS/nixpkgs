{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.138";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vn45hvwk49cfm283yg4j76k7dnn351rg5zy28z3bfp02x7cdyg6";
  };
} // (args.argsOverride or {}))
