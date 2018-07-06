{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.111";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1par6wjpr05k00nj0laxnjr02z75szpzvwv66wb0yn6wb64marjr";
  };
} // (args.argsOverride or {}))
