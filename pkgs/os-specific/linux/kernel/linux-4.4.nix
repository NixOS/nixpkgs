{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.264";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1b0d735qnk0bcqn9gdsjqxhk8pkb3597ya9f34lv1vjfaqkkxk7l";
  };
} // (args.argsOverride or {}))
