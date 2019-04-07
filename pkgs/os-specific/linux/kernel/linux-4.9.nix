{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.167";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "130a7z31sdha84w67vfx0j1sq68v15aksfkcshz219p75y561f52";
  };
} // (args.argsOverride or {}))
