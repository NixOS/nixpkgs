{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.155";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "179w0yfnqk0rjdfl3fjqx5b9jn8i0bizhqckv49f63rwwc5wcam5";
  };
} // (args.argsOverride or {}))
