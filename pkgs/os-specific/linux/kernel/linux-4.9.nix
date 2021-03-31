{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.264";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1df2dv26c9z6zsdlqzbcc60f2pszh0hx1n94v65jswlb72a2mipc";
  };
} // (args.argsOverride or {}))
