{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.160";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0585yq8zcq5l7f7mxl4vqnvqzj2qvrl9j9rwwgsrklk2mxkz16n0";
  };
} // (args.argsOverride or {}))
