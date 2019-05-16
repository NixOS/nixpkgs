{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.179";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1l979wmxridq9psjlhmgkax3bi769pvmmvdgf0j2y67gclkrssic";
  };
} // (args.argsOverride or {}))
