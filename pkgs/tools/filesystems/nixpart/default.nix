{ stdenv, fetchurl, buildPythonPackage, blivet
# Propagated to blivet
, useNixUdev ? null, udevSoMajor ? null
}:

let
  blivetOverrides = stdenv.lib.filterAttrs (k: v: v != null) {
    inherit useNixUdev udevSoMajor;
  };
in buildPythonPackage rec {
  name = "nixpart-${version}";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "03v2n2cf9cq9brnxx3yx26nsm3fkgdhmkcm52s89g33c1rmzzgbk";
  };

  propagatedBuildInputs = [ (blivet.override blivetOverrides) ];

  doCheck = false;

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
  };
}
