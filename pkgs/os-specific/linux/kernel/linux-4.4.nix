{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.205";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "19pasidvfmf94rs86v80x7hpirz9gavmkxwcl76ya61fq7lqy7zs";
  };
} // (args.argsOverride or {}))
