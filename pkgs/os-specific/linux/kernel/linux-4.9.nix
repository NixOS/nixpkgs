{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.154";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15jnkpf6kg061970cwh2z0l6nscffl63y1d0rq5f2y3gq4d4ycav";
  };
} // (args.argsOverride or {}))
