{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.157";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0kb23pq0q7nkrri4bir5x6285wbi17fn5mpbm9awzjablq5bq400";
  };
} // (args.argsOverride or {}))
