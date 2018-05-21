{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.132";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0d06dv7maspgv33dlc6r8cb8pkpg4q2vxbpzz6285n0ah4fb05f4";
  };
} // (args.argsOverride or {}))
