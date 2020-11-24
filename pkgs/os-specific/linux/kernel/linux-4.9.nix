{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.245";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vxsd3g96vbykrmfnj9qali0p868h678qzcqvf4yrhya47k6pnnb";
  };
} // (args.argsOverride or {}))
