{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.189";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0nc8v62gw89m3ykqg6nqf749fzm8y1n481ns8vny4gbinyikjhlp";
  };
} // (args.argsOverride or {}))
