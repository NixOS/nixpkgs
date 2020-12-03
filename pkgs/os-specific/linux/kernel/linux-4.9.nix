{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.247";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mngdbsq8pdzd0x9hif4715cc7wzc3ahgp1yrknnqk598q0fnfpp";
  };
} // (args.argsOverride or {}))
