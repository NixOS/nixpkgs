{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.261";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0d9j4j72n8fl3s93qm82cydwk8lvwhvl2357rcsai2vsk5l0k1mc";
  };
} // (args.argsOverride or {}))
