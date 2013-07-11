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
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "0v47vgj79k1idsvw7gd3g2vm5zfb2g4i2935y9sd2av5rb2w4c05";
  };

  propagatedBuildInputs = [ (blivet.override blivetOverrides) ];

  doCheck = false;

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
  };
}
