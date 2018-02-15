{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.81";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1bjwca7m3ksab6d23a05ciphzaj6nv6qmc5n6dxrgim0yhjpmvk4";
  };
} // (args.argsOverride or {}))
