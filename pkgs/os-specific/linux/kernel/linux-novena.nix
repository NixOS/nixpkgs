{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4-novena-r9";
  modDirVersion = "4.4.0";

  src = fetchurl {
    url = "https://github.com/xobs/novena-linux/archive/v${version}.tar.gz";
    name = "novena-linux-v${version}.tar.gz";
    sha256 = "1wcv1y2yxgbcda16v1a2i1dypc1mppslcfdq2if8x0bicn6cb61m";
  };

  extraMeta.hydraPlatforms = [];
})
