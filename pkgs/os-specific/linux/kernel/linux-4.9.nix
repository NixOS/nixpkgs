{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.107";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1lya48grdgjjbzw8x5kvvblanfas23dcmchysnhwv5p0rq7g9rrw";
  };
} // (args.argsOverride or {}))
