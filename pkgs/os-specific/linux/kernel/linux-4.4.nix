{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.131";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02f7sx20l0ljkgffac0yqav1kk7x1gl6026icslcsnn46pfpl4k5";
  };
} // (args.argsOverride or {}))
