{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.171";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00bznn1x8rq0wgjpl8sbp0cp4mzpbzjdnf2rvm8rinklpy9dj723";
  };
} // (args.argsOverride or {}))
