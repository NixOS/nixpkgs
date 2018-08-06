{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.146";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1xbxw6yvbjam0xj8j44h730dpf5v94pcf9j7iivcmasgjp61120z";
  };
} // (args.argsOverride or {}))
