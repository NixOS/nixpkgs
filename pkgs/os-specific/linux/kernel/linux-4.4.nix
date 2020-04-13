{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.218";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0qzhcy8i111jbpnkpzq7hqf9nkwq4s7smi820hfvnmd2ky7cns7a";
  };
} // (args.argsOverride or {}))
