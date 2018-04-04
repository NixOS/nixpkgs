{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.92";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0r3fg3za68p6ls40svryqxixmlia2ql3hqnd1kvvrdw6wqgap382";
  };
} // (args.argsOverride or {}))
