{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.220";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0bhbkybzbdsbmrjmb5m7hxxl8b3v6n79zhh86cbr95kzg1hcgnfs";
  };
} // (args.argsOverride or {}))
