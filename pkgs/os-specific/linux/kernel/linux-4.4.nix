{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.244";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0brdj6z7flchig80ja0dhzcrpl743lh74s4r4r6prbgkksif9ahp";
  };
} // (args.argsOverride or {}))
