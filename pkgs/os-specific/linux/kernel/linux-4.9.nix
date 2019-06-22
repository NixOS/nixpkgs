{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.182";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15cnk5bmd7kd4ggjzrbs9fpc21wliqdrnfnpg623cf0639l14vmi";
  };
} // (args.argsOverride or {}))
