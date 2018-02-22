{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.116";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "18sz68gbms5rvjiy51b1dg1jlr7pwazw9fg6q5ffczk22icflvsn";
  };
} // (args.argsOverride or {}))
