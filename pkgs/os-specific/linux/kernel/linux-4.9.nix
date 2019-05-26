{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.178";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ri50wiwqxnrl26b48czqvblkc20ys779x17x7wyk72xfaqdizqk";
  };
} // (args.argsOverride or {}))
