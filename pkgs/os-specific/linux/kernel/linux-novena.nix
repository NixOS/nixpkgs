{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4-novena-r9";
  modDirVersion = "4.4.0";

  src = fetchurl {
    url = "https://github.com/xobs/novena-linux/archive/v${version}.tar.gz";
    name = "novena-linux-v${version}.tar.gz";
    sha256 = "1ndcb8qsxryx3ja5fwydcsdbplmj5jbjv1b11wna9vdby90wcvdx";
  };

  extraMeta.hydraPlatforms = [];
})
