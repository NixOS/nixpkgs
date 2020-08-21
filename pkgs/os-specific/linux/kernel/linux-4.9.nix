{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.233";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "19dcwylhy5iqq3dmppqf7s9wy9d16m103djn1n183c9acnqclv9a";
  };
} // (args.argsOverride or {}))
