{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.162";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mdc1l89kbdzmaxn61hvndanamclykc7vq8wyp6b3qf4vi7g8imr";
  };
} // (args.argsOverride or {}))
