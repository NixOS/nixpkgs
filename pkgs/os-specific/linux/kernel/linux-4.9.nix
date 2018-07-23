{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.114";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1c3j82rcnj03bk5s2i11mhksv5l09hmkfs3rpbj5msnrn123ds76";
  };
} // (args.argsOverride or {}))
