{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.170";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "078k8dz3nmici7rs7x25h4vr1qaa588zwymv4gs722wfzi07p21k";
  };
} // (args.argsOverride or {}))
