{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.182";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "09w5v06c2ghai2pyz04kbhgfnqr22v4dkm9npb5kg6ndc67xh2f4";
  };
} // (args.argsOverride or {}))
