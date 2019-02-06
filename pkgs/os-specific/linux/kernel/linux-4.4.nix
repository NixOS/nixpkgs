{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.173";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0wj2y6y2ac5m6p6ghb4rmxfdxyx0gq7yv7b0qzmdyh4dkpi7qa0f";
  };
} // (args.argsOverride or {}))
