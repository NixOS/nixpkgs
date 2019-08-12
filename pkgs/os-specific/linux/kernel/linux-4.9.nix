{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.189";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1cyhwnxkjd0qa5d48657yppjnzbi830q0p25jjv2dxs629k4bnck";
  };
} // (args.argsOverride or {}))
