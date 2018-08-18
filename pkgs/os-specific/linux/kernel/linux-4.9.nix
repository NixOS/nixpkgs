{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.121";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0q8naw5jqpwa2ylwkbw88yz6zcnkr5jma91rr2xnll02mg8ri35s";
  };
} // (args.argsOverride or {}))
