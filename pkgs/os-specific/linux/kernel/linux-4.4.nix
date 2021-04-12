{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.266";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00x2dmjiiv9zpc0vih9xqmf78kynqzj9q9v1chc2q2hcjpqfj31c";
  };
} // (args.argsOverride or {}))
