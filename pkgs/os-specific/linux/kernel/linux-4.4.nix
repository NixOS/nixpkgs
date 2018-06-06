{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.135";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1p41fz1jhcrzcmvhbl8di1660bv0w2wpcmi4hfgksdjfh84b1k03";
  };
} // (args.argsOverride or {}))
