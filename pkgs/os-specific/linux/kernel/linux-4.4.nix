{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.134";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14gvkpdm3wbdfifnkrlk8b3i2isb439prqrzzlvjh88h582x4y20";
  };
} // (args.argsOverride or {}))
